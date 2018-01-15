//
//  HLSNative+ExposureContext+Timeshift.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-01-10.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation
import Player


// MARK: - Timeshift
extension Player where Tech == HLSNative<ExposureContext> {
    /// Specifies the timeshift delay *in seconds* associated with the current `MediaSource` (if available).
    ///
    /// Setting a value will cause the stream to reload starting from the new, timeshifted live point. Negative timeshift delays will be clamped at zero.
    ///
    /// - note: Requires a *Unified Packager* sourced stream.
    public var timeshiftDelay: Int64? {
        get {
            return tech.currentSource?.timeshiftDelay
        }
        set {
            // TODO: Shouldnt this be limited to playback of *live* entitlements?
            guard let currentSource = tech.currentSource, currentSource.isUnifiedPackager else { return }
            
            currentSource.timeshiftDelay = newValue
            print(#function,currentSource.url)
            tech.reloadSource()
        }
    }
    
    /// Returns the playhead position mapped to the cached server synced `currentTime` in unix epoch (milliseconds)
    ///
    /// Will return `nil` if no server time has been synched yet.
    public var playheadTime: Int64? {
        guard let current = currentTime else { return nil }
        return current - (timeshiftDelay ?? 0)*1000
    }
}
