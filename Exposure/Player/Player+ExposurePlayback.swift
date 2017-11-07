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
}

extension Player {
    /// Initiates a playback session by requesting a *vod* entitlement and preparing the player.
    ///
    /// Ensuring *EMP Analytics* works as intended requires this to be the only **entry point** for starting vod playback. Using any other means to start a streaming session may result in unwanted or inconsistent event reporting.
    ///
    /// Calling this method during an active playback session will terminate that session and dispatch the appropriate *Aborted* events.
    ///
    /// - parameter assetId: EMP asset id for which to request playback.
    /// - parameter callback: `PlaybackEntitlement` if the request was successful, `AnalyticsError` otherwise.
    public func stream(vod assetId: String, callback: @escaping (PlaybackEntitlement?, ExposureError?) -> Void) {
        guard let generator = analyticsProviderGenerator, let provider = generator() as? ExposureAnalyticsProvider else {
            callback(nil, .analytics(reason: .analyticsProviderMissing))
            return
        }
        
        // Save this assetData for later use
        let assetIdentifier = AssetIdentifier.vod(assetId: assetId)
        
        // Prepare the next event
        let startupEvents = provider.prepareStartupEvents(for: assetIdentifier, autoplay: autoplay)
        
        
        Entitlement(environment: provider.environment,
                    sessionToken: provider.sessionToken)
            .vod(assetId: assetId)
            .request()
            .validate()
            .response{ [weak self] (exposureResponse: ExposureResponse<PlaybackEntitlement>) in
                if let success = exposureResponse.value {
                    self?.finalize(playback: success, statupEvents: startupEvents, assetIdentifier: assetIdentifier, using: provider, callback: callback)
                }
                else if let error = exposureResponse.error {
                    callback(nil, error)
                }
        }
    }
    
    /// Initiates a playback session by requesting a *live* entitlement and preparing the player.
    ///
    /// Ensuring *EMP Analytics* works as intended requires this to be the only **entry point** for starting live playback. Using any other means to start a streaming session may result in unwanted or inconsistent event reporting.
    ///
    /// Calling this method during an active playback session will terminate that session and dispatch the appropriate *Aborted* events.
    ///
    /// - parameter channelId: EMP channel id for which to request playback.
    /// - parameter callback: `PlaybackEntitlement` if the request was successful, `AnalyticsError` otherwise.
    public func stream(live channelId: String, callback: @escaping (PlaybackEntitlement?, ExposureError?) -> Void) {
        guard let generator = analyticsProviderGenerator, let provider = generator() as? ExposureAnalyticsProvider else {
            callback(nil, .analytics(reason: .analyticsProviderMissing))
            return
        }
        
        // Save this assetData for later use
        let assetIdentifier = AssetIdentifier.live(channelId: channelId)
        
        // Prepare the next event
        let startupEvents = provider.prepareStartupEvents(for: assetIdentifier, autoplay: autoplay)
        
        let entitlement = Entitlement(environment: provider.environment,
                                      sessionToken: provider.sessionToken)
            .live(channelId: channelId)
        
        entitlement
            .request()
            .validate()
            .response{ [weak self] (exposure: ExposureResponse<PlaybackEntitlement>) in
                if let error = exposure.error {
                    // Workaround until EMP-10023 is fixed
                    if case let .exposureResponse(reason: reason) = error, (reason.httpCode == 403 && reason.message == "NO_MEDIA_ON_CHANNEL") {
                        entitlement
                            .use(drm: .unencrypted)
                            .request()
                            .validate()
                            .response{ [weak self] (exposure: ExposureResponse<PlaybackEntitlement>) in
                                if let error = exposure.error {
                                    callback(nil, error)
                                }
                                else if let success = exposure.value {
                                    self?.finalize(playback: success, statupEvents: startupEvents, assetIdentifier: assetIdentifier, using: provider, callback: callback)
                                }
                        }
                    }
                    else {
                        callback(nil, error)
                    }
                }
                else if let success = exposure.value {
                    self?.finalize(playback: success, statupEvents: startupEvents, assetIdentifier: assetIdentifier, using: provider, callback: callback)
                }
        }
    }
    
    
    /// Initiates a playback session by requesting a *cathcup* entitlement and preparing the player.
    ///
    /// Ensuring *EMP Analytics* works as intended requires this to be the only **entry point** for starting cathcup playback. Using any other means to start a streaming session may result in unwanted or inconsistent event reporting.
    ///
    /// Calling this method during an active playback session will terminate that session and dispatch the appropriate *Aborted* events.
    ///
    /// - parameter programId: EMP program id for which to request playback.
    /// - parameter channelId: EMP channel id for which to request playback.
    /// - parameter callback: `PlaybackEntitlement` if the request was successful, `AnalyticsError` otherwise.
    public func stream(programId: String, channelId: String, callback: @escaping (PlaybackEntitlement?, ExposureError?) -> Void) {
        guard let generator = analyticsProviderGenerator, let provider = generator() as? ExposureAnalyticsProvider else {
            callback(nil, .analytics(reason: .analyticsProviderMissing))
            return
        }
        
        // Save this assetData for later use
        let assetIdentifier = AssetIdentifier.catchup(channelId: channelId, programId: programId)
        
        // Prepare the next event
        let startupEvents = provider.prepareStartupEvents(for: assetIdentifier, autoplay: autoplay)
        
        
        let entitlement = Entitlement(environment: provider.environment,
                                      sessionToken: provider.sessionToken)
            .catchup(channelId: channelId,
                     programId: programId)
        
        entitlement
            .request()
            .validate()
            .response{ [weak self] (exposure: ExposureResponse<PlaybackEntitlement>) in
                if let error = exposure.error {
                    // Workaround until EMP-10023 is fixed
                    if case let .exposureResponse(reason: reason) = error, (reason.httpCode == 403 && reason.message == "NO_MEDIA_FOR_PROGRAM") {
                        entitlement
                            .use(drm: .unencrypted)
                            .request()
                            .validate()
                            .response{ [weak self] (exposure: ExposureResponse<PlaybackEntitlement>) in
                                if let error = exposure.error {
                                    callback(nil, error)
                                }
                                else if let success = exposure.value {
                                    self?.finalize(playback: success, statupEvents: startupEvents, assetIdentifier: assetIdentifier, using: provider, callback: callback)
                                }
                        }
                    }
                    else {
                        callback(nil, error)
                    }
                }
                else if let success = exposure.value {
                    self?.finalize(playback: success, statupEvents: startupEvents, assetIdentifier: assetIdentifier, using: provider, callback: callback)
                }
        }
    }
    
    
    /// Once an entitlement has been received from the backend, playback is ready to commence. This is a multi stage process involving analytics and player preparation. Streaming through the `Exposure` extensions on `Player` allows us to leverage the setup process related to *Fairplay*.
    private func finalize(playback entitlement: PlaybackEntitlement, statupEvents: [AnalyticsPayload], assetIdentifier: AssetIdentifier, using provider: ExposureAnalyticsProvider, callback: (PlaybackEntitlement?, ExposureError?) -> Void) {
        
        // If the startup events are enqueued before the player has initialized using the PlaybackEntitlement, we might not have a reference to the correct playSessionId.
        stream(playback: entitlement, analyticsProvider: provider)
        
        let handshake = provider.prepareHandshakeStarted(for: assetIdentifier, with: entitlement)
        var events = statupEvents
        events.append(handshake)
        
        provider.finalizePreparation(for: entitlement.playSessionId, startupEvents: events, asset: assetIdentifier, with: entitlement)
        callback(entitlement, nil)
    }
    
    
    /// Prepare the `player` for playback by configuring it with a `PlaybackEntitlement` supplied by exposure.
    ///
    /// If the requested content is *FairPlay* protected, the appropriate `FairplayRequester` will be created. Configuration will be taken from the supplied `entitlement`.
    ///
    /// Likewise, if `sessionShift(enabled: true)` has been specified, this method will attempt to configure playback to start at the `lastViewedOffset` in the supplied `entitlement`.
    /// Please note that a *manually* configured *Session Shift* through `sessionShift(enabledAt: someOffset)` will not be overriden. Use either a manual configuration or *Exposure*.
    ///
    /// - parameter entitlement: *Exposure* provided entitlement
    private func stream(playback entitlement: PlaybackEntitlement, analyticsProvider: ExposureAnalyticsProvider? = nil) {
        // Session shift
        handleSessionShift(entitlement: entitlement)
        
        // Fairplay
        let requester = ExposureStreamFairplayRequester(entitlement: entitlement)
        
        stream(url: entitlement.mediaLocator, using: requester, analyticsProvider: analyticsProvider, playSessionId: entitlement.playSessionId)
    }
}

// MARK: - SessionShift
extension Player {
    fileprivate func handleSessionShift(entitlement: PlaybackEntitlement) {
        // Make sure the user has specified sessionShift enabled
        guard sessionShiftEnabled else { return }
        
        // Make sure we do not override a manually set bookmark
        guard sessionShiftOffset == nil else { return }
        
        // Did the entitlement specify a `lastViewedOffset`?
        guard let offset = entitlement.lastViewedOffset else { return }
        
        sessionShift(enabledAt: Int64(offset))
    }
}
