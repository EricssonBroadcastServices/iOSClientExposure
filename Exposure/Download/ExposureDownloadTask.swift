//
//  ExposureDownloadTask.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-10-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import AVFoundation
import Download

public final class ExposureDownloadTask {
    internal var downloadTask: DownloadTask?
    internal var entitlementRequest: ExposureRequest?
    fileprivate(set) public var entitlement: PlaybackEntitlement?
    
    public let assetId: String
    public let environment: Environment
    public let sessionToken: SessionToken
    fileprivate let sessionManager: SessionManager
    
    internal init(assetId: String, environment: Environment, sessionToken: SessionToken, sessionManager: SessionManager) {
        self.assetId = assetId
        self.environment = environment
        self.sessionToken = sessionToken
        self.sessionManager = sessionManager
        self.playRequest = PlayRequest()
    }
    
    // DRMRequest
    public var playRequest: PlayRequest
    
    // Configuration
    fileprivate var requiredBitrate: Int64?
    
    // MARK: DownloadEventPublisher
    internal var onStarted: (ExposureDownloadTask) -> Void = { _ in }
    internal var onSuspended: (ExposureDownloadTask) -> Void = { _ in }
    internal var onResumed: (ExposureDownloadTask) -> Void = { _ in }
    internal var onCanceled: (ExposureDownloadTask, URL) -> Void = { _ in }
    internal var onCompleted: (ExposureDownloadTask, URL) -> Void = { _ in }
    internal var onProgress: (ExposureDownloadTask, DownloadTask.Progress) -> Void = { _ in }
    internal var onError: (ExposureDownloadTask, URL?, ExposureError) -> Void = { _ in }
    internal var onPlaybackReady: (ExposureDownloadTask, URL) -> Void = { _ in }
    internal var onShouldDownloadMediaOption: ((ExposureDownloadTask, AdditionalMedia) -> MediaOption?) = { _ in return nil }
    internal var onDownloadingMediaOption: (ExposureDownloadTask, MediaOption) -> Void = { _ in }
    
    // MARK: Entitlement
    internal var onEntitlementRequestStarted: (ExposureDownloadTask) -> Void = { _ in }
    internal var onEntitlementResponse: (ExposureDownloadTask, PlaybackEntitlement) -> Void = { _ in }
    internal var onEntitlementRequestCancelled: (ExposureDownloadTask) -> Void = { _ in }
}

extension ExposureDownloadTask: DRMRequest { }

extension ExposureDownloadTask: DownloadProcess {
    public func resume() {
        if let currentAsset = sessionManager.offline(assetId: assetId) {
            print("📍 Found bookmark for \(currentAsset.assetId), with url \(currentAsset.urlAsset?.url)")
        }
        
        guard let downloadTask = downloadTask else {
            guard let entitlementRequest = entitlementRequest else {
                startEntitlementRequest(assetId: assetId)
                return
            }
            entitlementRequest.resume()
            return
        }
        downloadTask.resume()
    }
    
    fileprivate func startEntitlementRequest(assetId: String) {
        entitlementRequest = Entitlement(environment: environment,
                                         sessionToken: sessionToken)
            .download(assetId: assetId)
            .use(drm: playRequest.drm)
            .use(format: playRequest.format)
            .request()
            .validate()
            .response{ [weak self] (res: ExposureResponse<PlaybackEntitlement>) in
                guard let weakSelf = self else { return }
                guard let entitlement = res.value else {
                    weakSelf.onError(weakSelf, nil, res.error!)
                    return
                }
                
                weakSelf.entitlementRequest = nil
                weakSelf.entitlement = entitlement
                weakSelf.onEntitlementResponse(weakSelf, entitlement)
                
                weakSelf.startDownloadTask(entitlement: entitlement, assetId: assetId)
        }
    }
    
    fileprivate func startDownloadTask(entitlement: PlaybackEntitlement, assetId: String) {
        guard let url = URL(string: entitlement.mediaLocator) else {
            onError(self, nil, .download(reason: .invalidMediaUrl(path: entitlement.mediaLocator)))
            return
        }
        
        let bps = requiredBitrate != nil ? requiredBitrate!*1000 : nil
        
        let fairplayRequester = ExposureDownloadFairplayRequester(entitlement: entitlement, assetId: assetId)
        
        // Store an initial locator to indicate download is underway
        sessionManager.save(assetId: assetId, entitlement: entitlement, url: nil)
        
        
        if #available(iOS 10.0, *) {
            // TODO: Artwork should probably be retrieved from *Exposure*
            downloadTask = sessionManager
                .download(mediaLocator: url,
                          assetId: assetId,
                          artwork: nil,
                          using: fairplayRequester)
        }
        else {
            do {
                let destinationUrl = try sessionManager
                    .baseDirectory()
                    .appendingPathComponent("\(assetId).m3u8")
                
                downloadTask = sessionManager
                    .download(mediaLocator: url,
                              assetId: assetId,
                              to: destinationUrl,
                              using: fairplayRequester)
            }
            catch {
                onError(self, nil, .download(reason: .failedToStartTaskWithoutDestination))
                return
            }
        }
        
        downloadTask?
            .use(bitrate: bps)
            .onStarted{ [weak self] task in
                if let weakSelf = self { weakSelf.onStarted(weakSelf) }
            }
            .onSuspended{ [weak self] task in
                if let weakSelf = self { weakSelf.onSuspended(weakSelf) }
            }
            .onResumed{ [weak self] task in
                if let weakSelf = self { weakSelf.onResumed(weakSelf) }
            }
            .onCanceled{ [weak self] task, url in
                if let weakSelf = self { weakSelf.onCanceled(weakSelf, url) }
            }
            .onCompleted{ [weak self] task, url in
                if let weakSelf = self {
                    // Update the tracked media with the location of the data
                    weakSelf.sessionManager.save(assetId: assetId, entitlement: entitlement, url: url)
                    weakSelf.onCompleted(weakSelf, url)
                }
            }
            .onProgress{ [weak self] task, progress in
                if let weakSelf = self { weakSelf.onProgress(weakSelf, progress) }
            }
            .onError{ [weak self] task, url, error in
                if let weakSelf = self {
                    weakSelf.sessionManager.save(assetId: assetId, entitlement: entitlement, url: url)
                    weakSelf.onError(weakSelf, url, ExposureError.download(reason: error))
                }
            }
            .onPlaybackReady{ [weak self] task, url in
                if let weakSelf = self { weakSelf.onPlaybackReady(weakSelf, url) }
            }
            .onShouldDownloadMediaOption{ [weak self] task, media in
                if let weakSelf = self { return weakSelf.onShouldDownloadMediaOption(weakSelf, media) }
                else { return nil }
            }
            .onDownloadingMediaOption{ [weak self] task, media in
                if let weakSelf = self { weakSelf.onDownloadingMediaOption(weakSelf, media) }
        }
        
        downloadTask?.resume()
    }
    
    
    public func suspend() {
        if let downloadTask = downloadTask {
            downloadTask.suspend()
        }
        else if let entitlementRequest = entitlementRequest {
            entitlementRequest.suspend()
        }
    }
    
    public func cancel() {
        if let downloadTask = downloadTask {
            downloadTask.cancel()
        }
        else if let entitlementRequest = entitlementRequest {
            entitlementRequest.cancel()
            onEntitlementRequestCancelled(self)
        }
    }
    
    public func use(bitrate: Int64?) -> Self {
        self.requiredBitrate = bitrate
        return self
    }
    
    public enum State {
        case notStarted
        case running
        case suspended
        case canceling
        case completed
    }
    
    public var state: State {
        guard let state = downloadTask?.state else { return .notStarted }
        switch state {
        case .notStarted: return .notStarted
        case .running: return .running
        case .suspended: return .suspended
        case .canceling: return .canceling
        case .completed: return .completed
        }
    }
}

extension ExposureDownloadTask: DownloadEventPublisher {
    public typealias DownloadEventProgress = DownloadTask.Progress
    public typealias DownloadEventError = ExposureError
    
    @discardableResult
    public func onStarted(callback: @escaping (ExposureDownloadTask) -> Void) -> ExposureDownloadTask {
        onStarted = callback
        return self
    }
    
    @discardableResult
    public func onSuspended(callback: @escaping (ExposureDownloadTask) -> Void) -> ExposureDownloadTask {
        onSuspended = callback
        return self
    }
    
    @discardableResult
    public func onResumed(callback: @escaping (ExposureDownloadTask) -> Void) -> ExposureDownloadTask {
        onResumed = callback
        return self
    }
    
    @discardableResult
    public func onCanceled(callback: @escaping (ExposureDownloadTask, URL) -> Void) -> ExposureDownloadTask {
        onCanceled = callback
        return self
    }
    
    @discardableResult
    public func onCompleted(callback: @escaping (ExposureDownloadTask, URL) -> Void) -> ExposureDownloadTask {
        onCompleted = callback
        return self
    }
    
    @discardableResult
    public func onProgress(callback: @escaping (ExposureDownloadTask, DownloadTask.Progress) -> Void) -> ExposureDownloadTask {
        onProgress = callback
        return self
    }
    
    @discardableResult
    public func onError(callback: @escaping (ExposureDownloadTask, URL?, ExposureError) -> Void) -> ExposureDownloadTask {
        onError = callback
        return self
    }
    
    @discardableResult
    public func onPlaybackReady(callback: @escaping (ExposureDownloadTask, URL) -> Void) -> ExposureDownloadTask {
        onPlaybackReady = callback
        return self
    }
    
    @discardableResult
    public func onShouldDownloadMediaOption(callback: @escaping (ExposureDownloadTask, AdditionalMedia) -> MediaOption?) -> ExposureDownloadTask {
        onShouldDownloadMediaOption = callback
        return self
    }
    
    @discardableResult
    public func onDownloadingMediaOption(callback: @escaping (ExposureDownloadTask, MediaOption) -> Void) -> ExposureDownloadTask {
        onDownloadingMediaOption = callback
        return self
    }
}

extension ExposureDownloadTask {
    @discardableResult
    public func onEntitlementRequestStarted(callback: @escaping (ExposureDownloadTask) -> Void) -> ExposureDownloadTask {
        onEntitlementRequestStarted = callback
        return self
    }
    
    @discardableResult
    public func onEntitlementResponse(callback: @escaping (ExposureDownloadTask, PlaybackEntitlement) -> Void) -> ExposureDownloadTask {
        onEntitlementResponse = callback
        return self
    }
    
    @discardableResult
    public func onEntitlementRequestCancelled(callback: @escaping (ExposureDownloadTask) -> Void) -> ExposureDownloadTask {
        onEntitlementRequestCancelled = callback
        return self
    }
}
