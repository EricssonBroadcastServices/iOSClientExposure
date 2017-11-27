//
//  HLSNative+ExposureContext+SessionShift.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Player

// MARK: - SessionShift
extension Player where Tech == HLSNative<ExposureContext> {
    internal func handleSessionShift(entitlement: PlaybackEntitlement) {
        // Make sure the user has specified sessionShift enabled
        guard tech.sessionShiftEnabled else { return }
        
        // Make sure we do not override a manually set bookmark
        guard tech.sessionShiftOffset == nil else { return }
        
        // Did the entitlement specify a `lastViewedOffset`?
        guard let offset = entitlement.lastViewedOffset else { return }
        
        tech.sessionShift(enabledAt: Int64(offset))
    }
}
