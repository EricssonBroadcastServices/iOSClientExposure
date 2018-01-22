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
    
    public var timeBehindLive: Int64? {
        if let last = seekableTimeRange.last?.1, let serverTime = serverTime {
            print("timeBehindLive",(last-serverTime)/1000)
            return last-serverTime
        }
        return 0
    }
    
    /// For playback content that is associated with a range of dates, move the playhead to point within that range.
    ///
    /// Will make another entitlement request and reload the stream if `timeInterval` falls outside the range or if the content is not associated with a range of dates.
    ///
    /// - parameter timeInterval: target timestamp in unix epoch time (milliseconds)
    public func seek(toTime timeInterval: Int64) {
        /// 1. Contract Restrictions
        
        /// 2. Seekable Range
        if let first = seekableTimeRange.first?.0, let last = seekableTimeRange.last?.1, let source = tech.currentSource {
            if timeInterval < first {
                // Before seekable range, new entitlement request required
                print("SEEK timeInterval < start")
            }
            else if timeInterval > last {
                // After seekable range
                print("SEEK timeInterval > end", date(date: Date(milliseconds: timeInterval), format: "HH:mm:ss"), date(date: Date(milliseconds: last), format: "HH:mm:ss"))
            }
            else {
                // Within bounds
                
                print("SEEK within bounds")
            }
        }
        
        // TODO: Seeking needs to update the
        if let programService = context.programService {
            programService.isEntitled(toPlay: timeInterval)
        }
        
        tech.seek(toTime: timeInterval)
        
    }
    
    /// Moves the playhead position to the specified offset in the players buffer
    ///
    /// Will make another entitlement request and reload the stream if `position` falls outside the seekable range
    ///
    /// - parameter position: target offset in milliseconds
    func seek(toPosition position: Int64) {
        /// 1. Contract Restrictions
        
        /// 2. Seekable Range
        if let first = seekableRange.first?.start.seconds, let last = seekableRange.last?.end.seconds, let source = tech.currentSource {
            if position < Int64(first * 1000) {
                // Before seekable range, new entitlement request required
                print("SEEK timeInterval < start")
            }
            else if position > Int64(last * 1000) {
                // After seekable range
                print("SEEK timeInterval > end")
            }
            else {
                // Within bounds
                
                print("SEEK within bounds")
            }
//
//            // TODO: Seeking needs to update the
//            if let programService = context.programService {
//                programService.isEntitled(toPlay: timeInterval)
//            }
//
//            tech.seek(toTime: timeInterval)
//
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
