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

typealias ExposureDownloadAnalyticsProvider = ExposureAnalyticsProvider & DownloadAnalyticsProvider

public final class ExposureDownloadTask: TaskType {
    
    internal var entitlementRequest: ExposureRequest?
    fileprivate(set) public var entitlement: PlaybackEntitlement?
    
    internal(set) public var task: AVAssetDownloadTask?
    public var configuration: Configuration
    public var responseData: ResponseData
    public var fairplayRequester: DownloadFairplayRequester?
    public let eventPublishTransmitter = Download.EventPublishTransmitter<ExposureDownloadTask>()
    
    public let sessionManager: SessionManager<ExposureDownloadTask>
    
    
    internal enum AnalyticsConfig {
        case valid(provider: ExposureDownloadAnalyticsProvider)
        case invalid
    }
    internal let analyticsConfig: AnalyticsConfig
    
    public lazy var delegate: Download.TaskDelegate = { [unowned self] in
        return Download.TaskDelegate(task: self)
        }()
    
    internal init(assetId: String, sessionManager: SessionManager<ExposureDownloadTask>, analyticsConfig: AnalyticsConfig) {
        self.configuration = Configuration(identifier: assetId)
        self.responseData = ResponseData()
        
        self.sessionManager = sessionManager
        self.playRequest = PlayRequest()
        
        self.analyticsConfig = analyticsConfig
    }
    
    // DRMRequest
    public var playRequest: PlayRequest
    
    // MARK: Entitlement
    internal var onEntitlementRequestStarted: (ExposureDownloadTask) -> Void = { _ in }
    internal var onEntitlementResponse: (ExposureDownloadTask, PlaybackEntitlement) -> Void = { _ in }
    internal var onEntitlementRequestCancelled: (ExposureDownloadTask) -> Void = { _ in }
}

extension ExposureDownloadTask: DRMRequest { }


extension ExposureDownloadTask {
    fileprivate func prepareFrom(offlineMediaAsset: OfflineMediaAsset, lazily: Bool, callback: @escaping () -> Void) {
        print("📍 Preparing ExposureDownloadTask from OfflineMediaAsset: \(offlineMediaAsset.assetId), lazily: \(lazily)")
        offlineMediaAsset.state{ [weak self] state in
            guard let weakSelf = self else { return }
            switch state {
            case .completed(entitlement: let entitlement, url: let url):
                weakSelf.onEntitlementResponse(weakSelf, entitlement)
                weakSelf.entitlement = entitlement
                // TODO: Ask for AdditionalMediaSelections?
                weakSelf.eventPublishTransmitter.onCompleted(weakSelf, url)
                callback()
            case .notPlayable(entitlement: let entitlement, url: _):
                if let entitlement = entitlement {
                    weakSelf.restoreOrCreate(for: entitlement, forceNew: lazily, callback: callback)
                }
                else {
                    weakSelf.startEntitlementRequest(assetId: weakSelf.configuration.identifier, lazily: lazily, callback: callback)
                }
            }
        }
    }
    
    fileprivate func restoreOrCreate(for entitlement: PlaybackEntitlement, forceNew: Bool, callback: @escaping () -> Void = { _ in }) {
        fairplayRequester = ExposureDownloadFairplayRequester(entitlement: entitlement, assetId: configuration.identifier)
        
        guard let targetUrl = URL(string: entitlement.mediaLocator) else {
            eventPublishTransmitter.onError(self, nil, .exposureDownload(reason: .invalidMediaUrl(path: entitlement.mediaLocator)))
            return
        }
        configuration.url = targetUrl
        
        sessionManager.restoreTask(with: configuration.identifier) { [weak self] restoredTask in
            guard let weakSelf = self else { return }
            if let restoredTask = restoredTask {
                weakSelf.configureResourceLoader(for: restoredTask)
                
                weakSelf.task = restoredTask
                weakSelf.sessionManager.delegate[restoredTask] = weakSelf
                
                weakSelf.handle(restoredTask: restoredTask)
            }
            else {
                if forceNew {
                    print("✅ No AVAssetDownloadTask prepared, creating new for: \(weakSelf.configuration.identifier)")
                    // Create a fresh task
                    let options = weakSelf.configuration.requiredBitrate != nil ? [AVAssetDownloadTaskMinimumRequiredMediaBitrateKey: weakSelf.configuration.requiredBitrate!] : nil
                    weakSelf.createAndConfigureTask(with: options, using: weakSelf.configuration) { urlTask, error in
                        if let error = error {
                            weakSelf.eventPublishTransmitter.onError(weakSelf, weakSelf.responseData.destination, error)
                            return
                        }
                        
                        if let urlTask = urlTask {
                            weakSelf.task = urlTask
                            weakSelf.sessionManager.delegate[urlTask] = weakSelf
                            print("👍 DownloadTask prepared")
                            weakSelf.eventPublishTransmitter.onPrepared(weakSelf)
                        }
                        callback()
                    }
                }
            }
        }
    }
    
    fileprivate func startEntitlementRequest(assetId: String, lazily: Bool, callback: @escaping () -> Void) {
        switch analyticsConfig {
        case .invalid:
            eventPublishTransmitter.onError(self, responseData.destination, .analytics(reason: .analyticsProviderMissing))
            return
        case .valid(provider: let analyticsProvider):
            entitlementRequest = Entitlement(environment: analyticsProvider.environment,
                                             sessionToken: analyticsProvider.sessionToken)
                .download(assetId: assetId)
                .use(drm: playRequest.drm)
                .use(format: playRequest.format)
                .request()
                .validate()
                .response{ [weak self] (res: ExposureResponse<PlaybackEntitlement>) in
                    guard let weakSelf = self else { return }
                    guard let entitlement = res.value else {
                        weakSelf.eventPublishTransmitter.onError(weakSelf, nil, res.error!)
                        return
                    }
                    
                    weakSelf.entitlementRequest = nil
                    weakSelf.entitlement = entitlement
                    weakSelf.onEntitlementResponse(weakSelf, entitlement)
                    
                    weakSelf.sessionManager.save(assetId: assetId, entitlement: entitlement, url: nil)
                    
                    weakSelf.restoreOrCreate(for: entitlement, forceNew: !lazily, callback: callback)
            }
        }
        
    }
}

extension ExposureDownloadTask {
    /// - parameter lazily: `true` will delay creation of new tasks until the user calls `resume()`. `false` will force create the task if none exists.
    @discardableResult
    public func prepare(lazily: Bool = true) -> ExposureDownloadTask {
        guard let task = task else {
            if let currentAsset = sessionManager.offline(assetId: configuration.identifier) {
                prepareFrom(offlineMediaAsset: currentAsset, lazily: lazily) {
                    
                }
            }
            else {
                startEntitlementRequest(assetId: configuration.identifier, lazily: lazily) {
                    
                }
            }
            return self
        }
        handle(restoredTask: task)
        return self
    }
    
    
    public func resume() {
        guard let downloadTask = task else {
            guard let entitlementRequest = entitlementRequest else {
                startEntitlementRequest(assetId: configuration.identifier, lazily: false) { [weak self] in
                    guard let `self` = self else { return }
                    `self`.task?.resume()
                    `self`.eventPublishTransmitter.onResumed(`self`)
                }
                return
            }
            entitlementRequest.resume()
            eventPublishTransmitter.onResumed(self)
            return
        }
        downloadTask.resume()
        eventPublishTransmitter.onResumed(self)
    }
    
    public func suspend() {
        if let downloadTask = task {
            downloadTask.suspend()
            eventPublishTransmitter.onSuspended(self)
        }
        else if let entitlementRequest = entitlementRequest {
            entitlementRequest.suspend()
            eventPublishTransmitter.onSuspended(self)
        }
    }
    
    public func cancel() {
        if let downloadTask = task {
            downloadTask.cancel()
        }
        else if let entitlementRequest = entitlementRequest {
            entitlementRequest.cancel()
            onEntitlementRequestCancelled(self)
        }
    }
    
    public func use(bitrate: Int64?) -> Self {
        self.configuration.requiredBitrate = bitrate
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
        guard let state = task?.state else { return .notStarted }
        switch state {
        case .running: return .running
        case .suspended: return .suspended
        case .canceling: return .canceling
        case .completed: return .completed
        }
    }
}

extension ExposureDownloadTask: Download.EventPublisher {
    public typealias DownloadEventError = ExposureError
    
    public func onCompleted(callback: @escaping (ExposureDownloadTask, URL) -> Void) -> ExposureDownloadTask {
        eventPublishTransmitter.onCompleted = { [weak self] task, url in
            guard let `self` = self else { return }
            `self`.sessionManager.save(assetId: `self`.configuration.identifier, entitlement: `self`.entitlement, url: url)
            callback(task,url)
        }
        return self
    }
    
    public func onError(callback: @escaping (ExposureDownloadTask, URL?, ExposureError) -> Void) -> ExposureDownloadTask {
        eventPublishTransmitter.onError = { [weak self] task, url, error in
            guard let `self` = self else { return }
            `self`.sessionManager.save(assetId: `self`.configuration.identifier, entitlement: `self`.entitlement, url: url)
            callback(task,url, error)
        }
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
