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
            self.handle(source: source, error: error, assetIdentifier: assetIdentifier, providers: providers)
        }
    }
    
    /// Initiates a live playback session by requesting an entitlement for `channelId`.
    ///
    /// Playback will start from the live edge.
    ///
    /// Calling this method during an active playback session will terminate that session and dispatch the appropriate *Aborted* events.
    ///
    /// - parameter programId: EMP program id for which to request playback.
    /// - parameter programId: EMP channel id for which to request playback.
    public func startPlayback(channelId: String) {
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
    /// Specifying `useBookmark = true` will start playback from the program start time.
    ///
    /// Calling this method during an active playback session will terminate that session and dispatch the appropriate *Aborted* events.
    ///
    /// - parameter programId: EMP program id for which to request playback.
    /// - parameter programId: EMP channel id for which to request playback.
    /// - parameter useBookmark: `true` if playback should start from the bookmarked position (if available).
    public func startPlayback(channelId: String, programId: String, useBookmark: Bool = true) {
        // Activate session shifting
        sessionShift(enabled: useBookmark)
        
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
            /// Make sure SessionShift is configured if specified by user
            handleSessionShift(entitlement: source.entitlement)
            
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

