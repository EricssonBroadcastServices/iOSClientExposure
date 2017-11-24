//
//  Player+ExposurePlayback.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-22.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Player

public enum AssetIdentifier {
    case vod(assetId: String?)
    case live(channelId: String?)
    case catchup(channelId: String?, programId: String?)
    case offline(assetId: String?)
    case download(assetId: String?)
}

public typealias ExposureStreamingAnalyticsProvider = ExposureAnalyticsProvider & AnalyticsProvider

public class ExposureContext: MediaContext {
    public typealias ContextError = ExposureError
    public typealias Source = ExposureSource
    
    public var analyticsGenerator: (ExposureContext.Source?) -> [AnalyticsProvider] = { _ in [] }
    
    public let environment: Environment
    public let sessionToken: SessionToken
    
    public init(environment: Environment, sessionToken: SessionToken, generator: @escaping () -> ExposureStreamingAnalyticsProvider) {
        self.environment = environment
        self.sessionToken = sessionToken
        self.exposureAnalyticsGenerator = generator
    }
    
    internal let exposureAnalyticsGenerator: () -> ExposureStreamingAnalyticsProvider
}

extension ExposureContext {
    internal func request(vod assetId: String, callback: @escaping (ExposureSource?, ExposureError?) -> Void) {
        Entitlement(environment: environment,
                    sessionToken: sessionToken)
            .vod(assetId: assetId)
            .request()
            .validate()
            .response{ [weak self] in
                self?.handle(response: $0, callback: callback)
        }
    }
    
    internal func request(live channelId: String, callback: @escaping (ExposureSource?, ExposureError?) -> Void) {
        let entitlement = Entitlement(environment: environment,
                                      sessionToken: sessionToken)
            .live(channelId: channelId)
        
        entitlement
            .request()
            .validate()
            .response{ [weak self] in
                if let error = $0.error {
                    // Workaround until EMP-10023 is fixed
                    if case let .exposureResponse(reason: reason) = error, (reason.httpCode == 403 && reason.message == "NO_MEDIA_ON_CHANNEL") {
                        entitlement
                            .use(drm: .unencrypted)
                            .request()
                            .validate()
                            .response{ [weak self] in
                                self?.handle(response: $0, callback: callback)
                        }
                    }
                    else {
                        callback(nil,error)
                    }
                }
                else if let entitlement = $0.value {
                    callback(ExposureSource(entitlement: entitlement), nil)
                }
        }
    }
    
    internal func request(program programId: String, channelId: String, callback: @escaping (ExposureSource?, ExposureError?) -> Void) {
        let entitlement = Entitlement(environment: environment,
                                      sessionToken: sessionToken)
            .catchup(channelId: channelId,
                     programId: programId)
        
        entitlement
            .request()
            .validate()
            .response{ [weak self] in
                if let error = $0.error {
                    // Workaround until EMP-10023 is fixed
                    if case let .exposureResponse(reason: reason) = error, (reason.httpCode == 403 && reason.message == "NO_MEDIA_FOR_PROGRAM") {
                        entitlement
                            .use(drm: .unencrypted)
                            .request()
                            .validate()
                            .response{ [weak self] in
                                self?.handle(response: $0, callback: callback)
                        }
                    }
                    else {
                        callback(nil,error)
                    }
                }
                else if let entitlement = $0.value {
                    callback(ExposureSource(entitlement: entitlement), nil)
                }
        }
    }
    
    private func handle(response: ExposureResponse<PlaybackEntitlement>, callback: @escaping (ExposureSource?, ExposureError?) -> Void) {
        if let entitlement = response.value {
            callback(ExposureSource(entitlement: entitlement), nil)
        }
        else {
            callback(nil,response.error!)
        }
    }
}

public class ExposureSource: MediaSource {
    public var analyticsConnector: AnalyticsConnector = PassThroughConnector()
    
    public var drmAgent: DrmAgent
    
    public var playSessionId: String {
        return ""
    }
    
    public var url: URL {
        return URL(fileURLWithPath: "")
    }
    
    public let entitlement: PlaybackEntitlement
    
    internal init(entitlement: PlaybackEntitlement) {
        self.entitlement = entitlement
        self.drmAgent = .external(agent: ExposureStreamFairplayRequester(entitlement: entitlement))
    }
}

extension ExposureSource: HLSNativeConfigurable {
    public var hlsNativeConfiguration: HLSNativeConfiguration {
        let drmAgent = ExposureStreamFairplayRequester(entitlement: entitlement)
        return HLSNativeConfiguration(url: url,
                                      playSessionId: entitlement.playSessionId,
                                      drm: drmAgent)
    }
}



extension Player where Tech == HLSNative<ExposureContext> {
    /// Initiates a playback session by requesting a *vod* entitlement and preparing the player.
    ///
    /// Calling this method during an active playback session will terminate that session and dispatch the appropriate *Aborted* events.
    ///
    /// - parameter assetId: EMP asset id for which to request playback.
    public func stream(vod assetId: String) {
        // Generate the analytics providers
        let providers = context.analyticsGenerator(nil)
        
        // Save this assetData for later use
        let assetIdentifier = AssetIdentifier.vod(assetId: assetId)
        
        // Initial analytics
        providers.forEach{
            if let exposureProvider = $0 as? ExposureStreamingAnalyticsProvider {
                exposureProvider.onEntitlementRequested(tech: tech, request: assetIdentifier)
            }
        }
        
        context.request(vod: assetId) { [weak self] source, error in
            guard let `self` = self else { return }
            `self`.handle(source: source, error: error, assetIdentifier: assetIdentifier, providers: providers)
        }
    }
    
    /// Initiates a playback session by requesting a *live* entitlement and preparing the player.
    ///
    /// Calling this method during an active playback session will terminate that session and dispatch the appropriate *Aborted* events.
    ///
    /// - parameter channelId: EMP channel id for which to request playback.
    public func stream(live channelId: String) {
        // Generate the analytics providers
        let providers = context.analyticsGenerator(nil)
        
        // Save this assetData for later use
        let assetIdentifier = AssetIdentifier.live(channelId: channelId)
        
        // Initial analytics
        providers.forEach{
            if let exposureProvider = $0 as? ExposureStreamingAnalyticsProvider {
                exposureProvider.onEntitlementRequested(tech: tech, request: assetIdentifier)
            }
        }
        
        context.request(live: channelId) { [weak self] source, error in
            guard let `self` = self else { return }
            `self`.handle(source: source, error: error, assetIdentifier: assetIdentifier, providers: providers)
        }
    }
    
    
    /// Initiates a playback session by requesting a *cathcup* entitlement and preparing the player.
    ///
    /// Calling this method during an active playback session will terminate that session and dispatch the appropriate *Aborted* events.
    ///
    /// - parameter programId: EMP program id for which to request playback.
    /// - parameter channelId: EMP channel id for which to request playback.
    public func stream(programId: String, channelId: String) {
        // Generate the analytics providers
        let providers = context.analyticsGenerator(nil)
        
        // Save this assetData for later use
        let assetIdentifier = AssetIdentifier.catchup(channelId: channelId, programId: programId)
        
        // Initial analytics
        providers.forEach{
            if let exposureProvider = $0 as? ExposureStreamingAnalyticsProvider {
                exposureProvider.onEntitlementRequested(tech: tech, request: assetIdentifier)
            }
        }
        
        context.request(program: programId, channelId: channelId) { [weak self] source, error in
            guard let `self` = self else { return }
            `self`.handle(source: source, error: error, assetIdentifier: assetIdentifier, providers: providers)
        }
    }
    
    
    private func handle(source: ExposureSource?, error: ExposureError?, assetIdentifier: AssetIdentifier, providers: [AnalyticsProvider]) {
        if let source = source {
            /// Make sure SessionShift is configured if specified by user
            `self`.handleSessionShift(entitlement: source.entitlement)
            
            /// Load tech
            `self`.tech.load(source: source)
            source.analyticsConnector.providers.forEach{
                if let exposureProvider = $0 as? ExposureStreamingAnalyticsProvider {
                    exposureProvider.onHandshakeStarted(tech: `self`.tech, source: source, request: assetIdentifier)
                }
            }
        }
        
        if let error = error {
            /// Deliver error
            let contextError = PlayerError<Tech, ExposureContext>.context(error: error)
            let nilSource: ExposureSource? = nil
            providers.forEach{ $0.onError(tech: `self`.tech, source: nilSource, error: contextError) }
            `self`.tech.eventDispatcher.onError(`self`.tech, nilSource, contextError)
        }
    }
}

// MARK: - SessionShift
extension Player where Tech: SessionShift {
    fileprivate func handleSessionShift(entitlement: PlaybackEntitlement) {
        // Make sure the user has specified sessionShift enabled
        guard tech.sessionShiftEnabled else { return }
        
        // Make sure we do not override a manually set bookmark
        guard tech.sessionShiftOffset == nil else { return }
        
        // Did the entitlement specify a `lastViewedOffset`?
        guard let offset = entitlement.lastViewedOffset else { return }
        
        tech.sessionShift(enabledAt: Int64(offset))
    }
}
