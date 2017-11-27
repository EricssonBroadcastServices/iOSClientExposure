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

extension Player where Tech == HLSNative<ExposureContext> {
    /// Initiates a playback session by requesting a *vod* entitlement and preparing the player.
    ///
    /// Calling this method during an active playback session will terminate that session and dispatch the appropriate *Aborted* events.
    ///
    /// - parameter assetId: EMP asset id for which to request playback.
    public func stream(vod assetId: String) {
        // Generate the analytics providers
        let providers = context.analyticsProviders(for: nil)
        
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
        let providers = context.analyticsProviders(for: nil)
        
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
        let providers = context.analyticsProviders(for: nil)
        
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
            source.analyticsConnector.providers = providers
            source.analyticsConnector.providers.forEach{
                if let exposureProvider = $0 as? ExposureStreamingAnalyticsProvider {
                    exposureProvider.onHandshakeStarted(tech: `self`.tech, source: source, request: assetIdentifier)
                    exposureProvider.finalizePreparation(for: source.entitlement.playSessionId, asset: assetIdentifier, with: source.entitlement, heartbeatsProvider: `self`.tech)
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


