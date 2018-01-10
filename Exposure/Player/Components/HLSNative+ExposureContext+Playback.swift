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
    case program(programId: String?, channelId: String?)
    case offline(assetId: String?)
    case download(assetId: String?)
}

extension Player where Tech == HLSNative<ExposureContext> {
    /// Initiates a playback session by requesting a *vod* entitlement and preparing the player.
    ///
    /// Calling this method during an active playback session will terminate that session and dispatch the appropriate *Aborted* events.
    ///
    /// - parameter assetId: EMP asset id for which to request playback.
    /// - parameter useBookmark: `true` if playback should start from the bookmarked position (if available). `false` will restart playback from the begining.
    public func startPlayback(assetId: String, useBookmark: Bool = true) {
        // Activate session shifting
        sessionShift(enabled: useBookmark)
        
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
    
    
    /// Initiates a playback session by requesting an entitlement for `channelId`, optionally specifying a `programId`. Leaving `programId` empty will request the currently live program.
    ///
    /// Behavior when disabling bookmarks for program playback depends on if the requested program is currently live or not.
    ///
    /// * Live program with bookmarks `false`: Playback starts from the live edge
    /// * Catchup program (not live) with bookmarks `false`: Playback starts from the begining of the program.
    ///
    /// Calling this method during an active playback session will terminate that session and dispatch the appropriate *Aborted* events.
    ///
    /// - parameter programId: EMP program id for which to request playback.
    /// - parameter programId: EMP channel id for which to request playback.
    /// - parameter useBookmark: `true` if playback should start from the bookmarked position (if available).
    public func startPlayback(channelId: String, programId: String? = nil, useBookmark: Bool = true) {
        // Activate session shifting
        sessionShift(enabled: useBookmark)
        
        // Generate the analytics providers
        let providers = context.analyticsProviders(for: nil)
        
        // Save this assetData for later use
        let assetIdentifier = programId == nil ? AssetIdentifier.live(channelId: channelId) : AssetIdentifier.program(programId: programId, channelId: channelId)
        
        // Initial analytics
        providers.forEach{
            if let exposureProvider = $0 as? ExposureStreamingAnalyticsProvider {
                exposureProvider.onEntitlementRequested(tech: tech, request: assetIdentifier)
            }
        }
        
        if let programId = programId {
            context.request(program: programId, channelId: channelId) { [weak self] source, error in
                guard let `self` = self else { return }
                `self`.handle(source: source, error: error, assetIdentifier: assetIdentifier, providers: providers)
            }
        }
        else {
            context.request(live: channelId) { [weak self] source, error in
                guard let `self` = self else { return }
                `self`.handle(source: source, error: error, assetIdentifier: assetIdentifier, providers: providers)
            }
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


