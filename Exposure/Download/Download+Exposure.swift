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
internal class ExposureDownloadFairplayRequester: NSObject, ExposureFairplayRequester, DownloadFairplayRequester {
    
    init(entitlement: PlaybackEntitlement) {
        self.entitlement = entitlement
    }
    
    internal let entitlement: PlaybackEntitlement
    internal let resourceLoadingRequestQueue = DispatchQueue(label: "com.emp.exposure.offline.fairplay.requests")
    internal let customScheme = "skd"
    internal let resourceLoadingRequestOptions: [String : AnyObject]? = [AVAssetResourceLoadingRequestStreamingContentKeyRequestRequiresPersistentKey: true as AnyObject]
    
    
    internal func onSuccessfulRetrieval(of ckc: Data, for resourceLoadingRequest: AVAssetResourceLoadingRequest) throws -> Data {
        // Obtain a persistable content key from a context.
        //
        // The data returned from this method may be used to immediately satisfy an
        // AVAssetResourceLoadingDataRequest, as well as any subsequent requests for the same key url.
        //
        // The value of AVAssetResourceLoadingContentInformationRequest.contentType must be set to AVStreamingKeyDeliveryPersistentContentKeyType when responding with data created with this method.
        var error: NSError?
        let persistedContentKey = resourceLoadingRequest.persistentContentKey(fromKeyVendorResponse: ckc, options: nil, error: &error)
        
        guard error == nil else {
            throw error!
        }
        
        return persistedContentKey
    }
    
    func shouldContactRemote(for resourceLoadingRequest: AVAssetResourceLoadingRequest) throws -> Bool {
        guard resourceLoadingRequest.contentInformationRequest != nil else {
            throw ExposureError.fairplay(reason: .contentInformationRequestMissing)
        }
        
        resourceLoadingRequest.contentInformationRequest?.contentType = AVStreamingKeyDeliveryPersistentContentKeyType
        
        guard let dataRequest = resourceLoadingRequest.dataRequest else {
            throw ExposureError.fairplay(reason: .missingDataRequest)
        }
        
        // Check if we can handle the request with a previously persisted content key
        if let keyData = persistedContentKey {
            dataRequest.respond(with: keyData)
            resourceLoadingRequest.finishLoading()
            return false
        }
        return true
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
