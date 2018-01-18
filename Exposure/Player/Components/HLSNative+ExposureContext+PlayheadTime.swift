//
//  HLSNative+ExposureContext+PlayheadTime.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-01-17.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation
import Player

// MARK: - Playhead Time
extension Player where Tech == HLSNative<ExposureContext> {
    /// For playback content that is associated with a range of dates, move the playhead to point within that range.
    ///
    /// Will make another entitlement request and reload the stream if `timeInterval` falls outside the range (ie outside the `dvr_window`) or if the content is not associated with a range of dates.
    ///
    /// - Parameter timeInterval: target timestamp in unix epoch time (milliseconds)
    public func seek(toTime timeInterval: Int64) {
        let date = Date(milliseconds: timeInterval)
        let timestamp = context.monotonicTimeService.monotonicTime(date: date) ?? timeInterval
        
        
        // TODO: Seeking needs to update the 
        if let programService = context.programService {
            
        }
        else {
            tech.seek(toTime: timestamp)
        }
    }
    
    /// Returns the playhead position mapped to wallclock time, in unix epoch (milliseconds)
    ///
    /// Will return `nil` if playback is not mapped to any date or if no syched servertime exists
    public var playheadTime: Int64? {
        guard let current = tech.playheadTime else { return nil }
        let date = Date(milliseconds: current)
        return context.monotonicTimeService.monotonicTime(date: date) ?? current
        
//        guard let source = tech.currentSource, source.isUnifiedPackager else {
//            return tech.playheadTime
//        }
//
//        guard let wallclock = serverTime else { return nil }
//        guard let dvrWindow = dvrWindowLength else { return nil }
//        let timeshift = timeshiftDelay ?? 0
//
//        return wallclock - timeshift*1000 - dvrWindow*1000 + playheadPosition
    }
}
