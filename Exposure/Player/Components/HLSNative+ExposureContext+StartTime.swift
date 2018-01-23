//
//  HLSNative+ExposureContext+StartTime.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Player

// MARK: - StartTime
extension Player where Tech == HLSNative<ExposureContext> {
    internal func handleStartTime(source: ExposureSource, assetIdentifier: AssetIdentifier) {
        switch assetIdentifier {
        case .live(channelId: _): liveStartTime(source: source)
        case .program(programId: _, channelId: _): programStartTime(source: source)
        case .vod(assetId: _): vodStarTime(source: source)
        default: return
        }
    }
    
    private static let segmentLength: Int64 = 6000
    private func vodStarTime(source: ExposureSource) {
        switch context.playbackProperties.playFrom {
        case .defaultBehaviour:
            defaultVodStartTime(source: source)
        case .beginning:
            // Start from offset 0
            tech.startOffset(atPosition: 0)
        case .bookmark:
            // Use *EMP* supplied bookmark, else default behaviour (ie nil bookmark)
            if let offset = source.entitlement.lastViewedOffset {
                tech.startOffset(atPosition: Int64(offset))
            }
            else {
                defaultVodStartTime(source: source)
            }
        case .custom(offset: let offset):
            // Use the custom supplied offset
            tech.startOffset(atPosition: offset)
        }
    }
    
    private func defaultVodStartTime(source: ExposureSource) {
        // Default is to start from the beginning
        tech.startOffset(atPosition: nil)
    }
    
    private func programStartTime(source: ExposureSource) {
        switch context.playbackProperties.playFrom {
        case .defaultBehaviour:
            defaultProgramStartTime(source: source)
        case .beginning:
            if source.isUnifiedPackager {
                // Start from  program start (using a t-param with stream start at program start)
                tech.startOffset(atPosition: 0 + Player.segmentLength)
            }
            else {
                // Relies on traditional vod manifest
                tech.startOffset(atPosition: nil)
            }
        case .bookmark:
            // Use *EMP* supplied bookmark
            if let offset = source.entitlement.lastViewedOffset {
                if source.isUnifiedPackager {
                    tech.startOffset(atPosition: Int64(offset))
                    // Wallclock timestamp
//                    tech.startOffset(atTime: Int64(offset))
                }
                else {
                    // 0 based offset
                    tech.startOffset(atPosition: Int64(offset))
                }
            }
            else {
                defaultProgramStartTime(source: source)
            }
        case .custom(offset: let offset):
            // Use the custom supplied offset
            if source.isUnifiedPackager {
                // Wallclock timestamp
                tech.startOffset(atTime: offset)
            }
            else {
                // 0 based offset
                tech.startOffset(atPosition: offset)
            }
        }
    }
    
    private func defaultProgramStartTime(source: ExposureSource) {
        if source.isUnifiedPackager {
            if source.entitlement.live {
                // Start from the live edge (relying on live manifest)
                tech.startOffset(atTime: nil)
            }
            else {
                // Start from program start (using a t-param with stream start at program start)
                tech.startOffset(atPosition: 0 + Player.segmentLength)
            }
        }
        else {
            // Default is to start from program start (relying on traditional vod manifest)
            tech.startOffset(atPosition: nil)
        }
    }
    
    private func liveStartTime(source: ExposureSource) {
        switch context.playbackProperties.playFrom {
        case .defaultBehaviour:
            defaultLiveStartTime(source: source)
        case .beginning:
            if source.isUnifiedPackager {
                // Start from  program start (using a t-param with stream start at program start)
                tech.startOffset(atPosition: 0 + Player.segmentLength)
            }
            else {
                // Relies on traditional vod manifest
                tech.startOffset(atPosition: nil)
            }
        case .bookmark:
            // Use *EMP* supplied bookmark
            if let offset = source.entitlement.lastViewedOffset {
                if source.isUnifiedPackager {
                    // Wallclock timestamp
                    tech.startOffset(atTime: Int64(offset))
                }
                else {
                    // 0 based offset
                    tech.startOffset(atPosition: Int64(offset))
                }
            }
            else {
                defaultLiveStartTime(source: source)
            }
        case .custom(offset: let offset):
            // Use the custom supplied offset
            if source.isUnifiedPackager {
                // Wallclock timestamp
                tech.startOffset(atTime: offset)
            }
            else {
                // 0 based offset
                tech.startOffset(atPosition: offset)
            }
        }
    }
    
    private func defaultLiveStartTime(source: ExposureSource) {
        if source.isUnifiedPackager {
            // Start from the live edge (relying on live manifest)
            tech.startOffset(atTime: nil)
        }
        else {
            // Default is to start from  live edge (relying on live manifest)
            tech.startOffset(atPosition: nil)
        }
    }
}
