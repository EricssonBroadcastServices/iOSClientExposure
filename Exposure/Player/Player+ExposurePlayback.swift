//
//  Player+ExposurePlayback.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-22.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Player

extension Player {
    /// Prepare the `player` for playback by configuring it with a `PlaybackEntitlement` supplied by exposure.
    ///
    /// If the requested content is *FairPlay* protected, the appropriate `FairplayRequester` will be created. Configuration will be taken from the supplied `entitlement`.
    ///
    /// Likewise, if `sessionShift(enabled: true)` has been specified, this method will attempt to configure playback to start at the `lastViewedOffset` in the supplied `entitlement`.
    /// Please note that a *manually* configured *Session Shift* through `sessionShift(enabledAt: someOffset)` will not be overriden. Use either a manual configuration or *Exposure*.
    ///
    /// - parameter entitlement: *Exposure* provided entitlement
    /// - throws: `PlayerError`
    public func stream(playback entitlement: PlaybackEntitlement) throws {
        guard let mediaLocator = entitlement.mediaLocator else {
            throw PlayerError.asset(reason: .missingMediaUrl)
        }
        
        // Session shift
        handleSessionShift(entitlement: entitlement)
        
        // Fairplay
        let requester = ExposureFairplayRequester(entitlement: entitlement)
        
        stream(url: mediaLocator, using: requester, playSessionId: entitlement.playSessionId)
    }
    
    public func offline(playback entitlement: PlaybackEntitlement) throws {
        
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
