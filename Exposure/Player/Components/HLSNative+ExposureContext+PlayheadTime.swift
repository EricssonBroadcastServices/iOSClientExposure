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
        
        // TODO: `timeInterval` is in unix epoch worldclock time. This needs to be synced with the serverTime.
        
        
        
//        let date = Date(milliseconds: timeInterval)
//        currentAsset?.playerItem.seek(to: date) { [weak self] success in
//            guard let `self` = self else { return }
//            if success {
//                if let source = self.currentAsset?.source {
//                    self.eventDispatcher.onPlaybackScrubbed(self, source, timeInterval)
//                    source.analyticsConnector.onScrubbedTo(tech: self, source: source, offset: timeInterval) }
//            }
//        }
    }
    
    /// Returns the playhead position mapped current time, in unix epoch (milliseconds)
    ///
    /// Requires a stream expressing the `EXT-X-PROGRAM-DATE-TIME` tag.
    ///
    /// Will return `nil` if playback is not mapped to any date.
//    public var playheadTime: Int64? {
//        guard let streamTime = tech.playheadTime else { return nil }
//        
//        /// Buffer end
//        guard let bufferEnd = tech.bufferedRange.last?.end.seconds else { return nil }
//        
//        // bufferEndTimestamp - playheadPosition
//        
//        
//        // TODO: Playhead time needs to be synched with the MonotonicTime
//    }
}
