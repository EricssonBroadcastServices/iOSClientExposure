//
//  Download+Exposure.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import AVFoundation
import Download

/// *Exposure* specific implementation of the `OfflineFairplayRequester` protocol.
///
/// This class handles any *Exposure* related `DRM` validation with regards to *Fairplay*. It is designed to be *plug-and-play* and should require no configuration to use.
internal class ExposureDownloadFairplayRequester: NSObject, DownloadFairplayRequester {
    /// Entitlement related to this specific *Fairplay* request.
    internal let entitlement: PlaybackEntitlement
    
    init(entitlement: PlaybackEntitlement) {
        self.entitlement = entitlement
    }
    
    /// The DispatchQueue to use for AVAssetResourceLoaderDelegate callbacks.
    fileprivate let resourceLoadingRequestQueue = DispatchQueue(label: "com.emp.exposure.offline.fairplay.requests")
    
    /// The URL scheme for FPS content.
    static let customScheme = "skd"
    
    /// Starting point for the *Fairplay* validation chain. Note that returning `false` from this method does not automatically mean *Fairplay* validation failed.
    ///
    /// - parameter resourceLoadingRequest: loading request to handle
    /// - returns: ´true` if the requester can handle the request, `false` otherwise.
    fileprivate func canHandle(resourceLoadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
        guard let url = resourceLoadingRequest.request.url else {
            return false
        }
        
        //EMPFairplayRequester only should handle FPS Content Key requests.
        if url.scheme != ExposureDownloadFairplayRequester.customScheme {
            return false
        }
        
        resourceLoadingRequestQueue.async { [unowned self] in
            self.handle(resourceLoadingRequest: resourceLoadingRequest)
        }
        
        return true
    }
    
    
    /// Handling a *Fairplay* validation request is a process in several parts:
    ///
    /// * If a persisted key exists, use that
    /// * Fetch and parse the *Application Certificate*
    /// * Request a *Server Playback Context*, `SPC`, for the specified asset using the *Application Certificate*
    /// * Request a *Content Key Context*, `CKC`, for the validated `SPC`.
    /// * Create a persisted key from the supplied `CKC`
    ///
    /// If this process fails, the `resourceLoadingRequest` will call `resourceLoadingRequest.finishLoading(with: someError`.
    ///
    /// For more information regarding *Fairplay* validation, please see Apple's documentation regarding *Fairplay Streaming*.
    fileprivate func handle(resourceLoadingRequest: AVAssetResourceLoadingRequest) {
        guard resourceLoadingRequest.contentInformationRequest != nil else {
            resourceLoadingRequest.finishLoading(with: ExposureError.fairplay(reason: .contentInformationRequestMissing))
        }
        resourceLoadingRequest.contentInformationRequest?.contentType = AVStreamingKeyDeliveryPersistentContentKeyType
        
        guard let url = resourceLoadingRequest.request.url,
            let assetIDString = url.host,
            let contentIdentifier = assetIDString.data(using: String.Encoding.utf8) else {
                resourceLoadingRequest.finishLoading(with: ExposureError.fairplay(reason: .invalidContentIdentifier))
                return
        }
        
        print(url, " - ",assetIDString)
        
        guard let dataRequest = resourceLoadingRequest.dataRequest else {
            resourceLoadingRequest.finishLoading(with: ExposureError.fairplay(reason: .missingDataRequest))
            return
        }
        
        // Check if we can handle the request with a previously persisted content key
        if let keyData = persistedContentKey {
            dataRequest.respond(with: keyData)
            resourceLoadingRequest.finishLoading()
            return
        }
        
        
        // Scenarios
        //
        // 1. Key Persisted
        //      * Supply key
        //
        // 2. Key Not Persisted
        //      
        
        // Scenarios
        //
        // 1. Download Asset
        //      * Download key
        //      * Download asset
        //
        // 2. Resume Download
        //      2.1 Key persisted
        //          * Continue download (or invalid key, error)
        //      2.2 Key NOT persisted
        //          * Try downloading key again?
        //          * Throw error?
        //
        // 3. Play Downloaded Asset
        //      2.1 Key persisted
        //          * Playback (or invalid key, error)
        //      2.2 Key NOT persisted
        //          * Throw error
        
        
        fetchApplicationCertificate{ [unowned self] certificate, certificateError in
            print("fetchApplicationCertificate")
            if let certificateError = certificateError {
                print("fetchApplicationCertificate ",certificateError.localizedDescription)
                resourceLoadingRequest.finishLoading(with: certificateError)
                return
            }
            
            if let certificate = certificate {
                print("prepare SPC")
                do {
                    let spcData = try resourceLoadingRequest.streamingContentKeyRequestData(forApp: certificate, contentIdentifier: contentIdentifier, options: resourceLoadingRequestOptions)
                    
                    // Content Key Context fetch from licenseUrl requires base64 encoded data
                    let spcBase64 = spcData.base64EncodedData(options: Data.Base64EncodingOptions.endLineWithLineFeed)
                    
                    self.fetchContentKeyContext(spc: spcBase64) { ckcBase64, ckcError in
                        print("fetchContentKeyContext")
                        if let ckcError = ckcError {
                            resourceLoadingRequest.finishLoading(with: ckcError)
                            return
                        }
                        
                        guard let dataRequest = resourceLoadingRequest.dataRequest else {
                            resourceLoadingRequest.finishLoading(with: ExposureError.fairplay(reason: .missingDataRequest))
                            return
                        }
                        
                        guard let ckcBase64 = ckcBase64 else {
                            resourceLoadingRequest.finishLoading(with: ExposureError.fairplay(reason: .missingContentKeyContext))
                            return
                        }
                        
                        // Provide data to the loading request.
                        dataRequest.respond(with: ckcBase64)
                        resourceLoadingRequest.finishLoading()  // Treat the processing of the request as complete.
                        
                    }
                }
                catch {
                    //                    -42656 Lease duration has expired.
                    //                    -42668 The CKC passed in for processing is not valid.
                    //                    -42672 A certificate is not supplied when creating SPC.
                    //                    -42673 assetId is not supplied when creating an SPC.
                    //                    -42674 Version list is not supplied when creating an SPC.
                    //                    -42675 The assetID supplied to SPC creation is not valid.
                    //                    -42676 An error occurred during SPC creation.
                    //                    -42679 The certificate supplied for SPC creation is not valid.
                    //                    -42681 The version list supplied to SPC creation is not valid.
                    //                    -42783 The certificate supplied for SPC is not valid and is possibly revoked.
                    print("SPC - ",error.localizedDescription)
                    print("SPC - ",error)
                    resourceLoadingRequest.finishLoading(with: ExposureError.fairplay(reason: .serverPlaybackContext(error: error)))
                    return
                }
            }
        }
    }
}

extension ExposureDownloadFairplayRequester {
    internal var persistedContentKey: Data? {
        guard let url = contentKeyUrl else { return nil }
        return try? Data(contentsOf: url)
    }
}
extension ExposureDownloadFairplayRequester {
    internal var contentKeyDirectory: URL? {
        return FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("download", isDirectory: true)
            .appendingPathComponent("keys", isDirectory: true)
    }
    
    internal var contentKeyUrl: URL? {
        return contentKeyDirectory?
            .appendingPathComponent("\(entitlement.mediaLocator)-key")
    }
}

// MARK: - AVAssetResourceLoaderDelegate
extension ExposureDownloadFairplayRequester {
    public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        return canHandle(resourceLoadingRequest: loadingRequest)
    }
    
    public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForRenewalOfRequestedResource renewalRequest: AVAssetResourceRenewalRequest) -> Bool {
        return canHandle(resourceLoadingRequest: renewalRequest)
    }
}

extension Downloader {
    /// Create a `DownloadTask` for an asset as specified by a `PlaybackEntitlement` supplied through exposure.
    ///
    /// If the requested content is *FairPlay* protected, the appropriate `OfflineFairplayRequester` will be created. Configuration will be taken from the supplied `entitlement`.
    ///
    /// - parameter entitlement: *Exposure* provided entitlement
    @available(iOS 10.0, *)
    public static func download(entitlement: PlaybackEntitlement) throws -> DownloadTask {
        let fairplayRequester = ExposureDownloadFairplayRequester(entitlement: entitlement)
        
        return try download(mediaLocator: entitlement.mediaLocator, named: entitlement.mediaLocator, artwork: nil, using: fairplayRequester)
    }
    
    @available(iOS, introduced: 9.0, deprecated: 10.0)
    public static func download(entitlement: PlaybackEntitlement, to url: URL) throws -> DownloadTask {
        let fairplayRequester = ExposureDownloadFairplayRequester(entitlement: entitlement)
        
        return try download(mediaLocator: entitlement.mediaLocator, to: url, using: fairplayRequester)
    }
}
