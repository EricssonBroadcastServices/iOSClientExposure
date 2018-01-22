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
    
    public var channelId: String? {
        switch self {
        case .live(channelId: let value): return value
        case .program(programId: _, channelId: let value): return value
        default: return nil
        }
    }
    
    public var programId: String? {
        switch self {
        case .program(programId: let value, channelId: _): return value
        default: return nil
        }
    }
}

extension Player where Tech == HLSNative<ExposureContext> {
    /// Initiates a playback session by requesting a *vod* entitlement and preparing the player.
    ///
    /// Specifying `useBookmark = true` will resume playback of the requested program from the previously saved position. If no bookmark is available playback will start from the beginning.
    ///
    /// Calling this method during an active playback session will terminate that session and dispatch the appropriate *Aborted* events.
    ///
    /// - parameter assetId: EMP asset id for which to request playback.
    /// - parameter properties: Properties specifying additional configuration for the playback
    public func startPlayback(assetId: String, properties: PlaybackProperties = PlaybackProperties()) {
        context.playbackProperties = properties
        
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
            self.handle(source: source, error: error, assetIdentifier: assetIdentifier, providers: providers)
        }
    }
    
    /// Initiates a live playback session by requesting an entitlement for `channelId`.
    ///
    /// Specifying `useBookmark = true` will resume playback of the requested program from the previously saved position. If no bookmark is available the channel will start from the live edge.
    ///
    /// Calling this method during an active playback session will terminate that session and dispatch the appropriate *Aborted* events.
    ///
    /// - parameter programId: EMP program id for which to request playback.
    /// - parameter properties: Properties specifying additional configuration for the playback
    public func startPlayback(channelId: String, properties: PlaybackProperties = PlaybackProperties()) {
        context.playbackProperties = properties
        
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
            self.handle(source: source, error: error, assetIdentifier: assetIdentifier, providers: providers)
        }
    }
    
    /// Initiates a playback session by requesting an entitlement for `programId` on `channelId`.
    ///
    /// Specifying `useBookmark = true` will resume playback of the requested program from the previously saved position. If no bookmark is available the program will start from the begining.
    ///
    /// Calling this method during an active playback session will terminate that session and dispatch the appropriate *Aborted* events.
    ///
    /// - parameter programId: EMP program id for which to request playback.
    /// - parameter programId: EMP channel id for which to request playback.
    /// - parameter properties: Properties specifying additional configuration for the playback
    public func startPlayback(channelId: String, programId: String, properties: PlaybackProperties = PlaybackProperties()) {
        context.playbackProperties = properties
        
        // Generate the analytics providers
        let providers = context.analyticsProviders(for: nil)
        
        // Save this assetData for later use
        let assetIdentifier = AssetIdentifier.program(programId: programId, channelId: channelId)
        
        // Initial analytics
        providers.forEach{
            if let exposureProvider = $0 as? ExposureStreamingAnalyticsProvider {
                exposureProvider.onEntitlementRequested(tech: tech, request: assetIdentifier)
            }
        }
        
        context.request(program: programId, channelId: channelId) { [weak self] source, error in
            guard let `self` = self else { return }
            self.handle(source: source, error: error, assetIdentifier: assetIdentifier, providers: providers)
        }
    }
    
    private func handle(source: ExposureSource?, error: ExposureError?, assetIdentifier: AssetIdentifier, providers: [AnalyticsProvider]) {
        if let source = source {
            /// Make sure StartTime is configured if specified by user
            handleStartTime(source: source, assetIdentifier: assetIdentifier)
            
            /// Start ProgramService
            prepareProgramService(source: source, assetIdentifier: assetIdentifier)
            
            /// Load tech
            tech.load(source: source)
            source.analyticsConnector.providers = providers
            source.analyticsConnector.providers.forEach{
                if let exposureProvider = $0 as? ExposureStreamingAnalyticsProvider {
                    exposureProvider.onHandshakeStarted(tech: tech, source: source, request: assetIdentifier)
                    exposureProvider.finalizePreparation(for: source.entitlement.playSessionId, asset: assetIdentifier, with: source.entitlement, heartbeatsProvider: tech)
                }
            }
        }
        
        if let error = error {
            /// Deliver error
            let contextError = PlayerError<Tech, ExposureContext>.context(error: error)
            let nilSource: ExposureSource? = nil
            providers.forEach{ $0.onError(tech: tech, source: nilSource, error: contextError) }
            tech.eventDispatcher.onError(tech, nilSource, contextError)
        }
    }
}


extension Player where Tech == HLSNative<ExposureContext> {
    fileprivate func prepareProgramService(source: ExposureSource, assetIdentifier: AssetIdentifier) {
        guard let channelId = assetIdentifier.channelId else  { return }
        let service = ProgramService(environment: context.environment, sessionToken: context.sessionToken, channelId: channelId)
        
        context.programService = service
        
        service.currentPlayheadTime = { [weak self] in return self?.playheadTime }
        service.onProgramChanged = { [weak self] program in
            guard let `self` = self else { return }
            self.context.onProgramChanged(program, source)
        }
        service.onNotEntitled = { message in
            // TODO: Stop playback and unload source
            print("NOT ENTITLED",message)
        }
        
        
        // TODO: Should be started once playback has started.
        service.startMonitoring()
    }
}

