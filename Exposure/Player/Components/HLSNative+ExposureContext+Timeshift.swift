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
    #if DEBUG
    /// Specifies the timeshift delay *in seconds* associated with the current `MediaSource` (if available).
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
            
            let tempDelta = (playheadTime ?? Date().millisecondsSince1970) - (timeshiftDelay ?? 0) * 1000
            context.programService?.isEntitled(toPlay: tempDelta)
            tech.reloadSource()
        }
    }
    
    public var dvrWindowLength: Int64? {
        return tech.currentSource?.dvrWindowLength
    }
    #endif
    
    public var tParameter: (Int64, Int64?)? {
        return tech.currentSource?.tParam
    }
}
