//
//  HLSNative+ExposureContext+StartTime.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Player

public struct PlaybackProperties {
    
    /// When autoplay is enabled, playback will resume as soon as the stream is loaded and prepared.
    public let autoplay: Bool
    
    /// `true` if playback should start from the bookmarked position (if available) or the default position if `false`.
    ///
    /// The default behaviour when bookmarks are disabled depends on the type of playback action taken.
    public let useBookmarks: Bool
    
    
    public init(autoplay: Bool = true, useBookmarks: Bool = true) {
        self.autoplay = autoplay
        self.useBookmarks = useBookmarks
    }
}

// MARK: - StartTime
extension Player where Tech == HLSNative<ExposureContext> {
    internal func handleStartTime(source: ExposureSource, assetIdentifier: AssetIdentifier) {
        let useBookmarks = context.playbackProperties.useBookmarks
        switch assetIdentifier {
        case .vod(assetId: _):
            let offset = useBookmarks ? source.entitlement.lastViewedOffset : nil
            tech.startOffset(atPosition: offset != nil ? Int64(offset!) : nil)
        case .live(channelId: _):
            if source.isUnifiedPackager {
                let offset = useBookmarks ? source.entitlement.liveTime : nil
                tech.startOffset(atTime: offset != nil ? Int64(offset!) : nil)
            }
            else {
                let offset = useBookmarks ? source.entitlement.lastViewedOffset : nil
                tech.startOffset(atPosition: offset != nil ? Int64(offset!) : nil)
            }
        case .program(programId: _, channelId: _):
            if source.isUnifiedPackager {
                let offset = useBookmarks ? source.entitlement.liveTime : nil
                tech.startOffset(atTime: offset != nil ? Int64(offset!) : nil)
            }
            else {
                let offset = useBookmarks ? source.entitlement.lastViewedOffset : nil
                tech.startOffset(atPosition: offset != nil ? Int64(offset!) : nil)
            }
        default:
            tech.startOffset(atPosition: nil)
        }
    }
    
}
