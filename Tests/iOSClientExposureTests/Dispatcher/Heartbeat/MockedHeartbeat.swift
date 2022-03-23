//
//  MockedHeartbeat.swift
//  AnalyticsTests
//
//  Created by Fredrik Sjöberg on 2017-12-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
@testable import iOSClientExposure

struct MockedHeartbeat: AnalyticsEvent {
    let eventType: String = "Playback.Heartbeat"
    let bufferLimit: Int64 = 3000
    let timestamp: Int64
    
    /// Offset in the video sequence where the playback was started at in milliseconds.
    let offsetTime: Int64
    
    init(timestamp: Int64, offsetTime: Int64) {
        self.timestamp = timestamp
        self.offsetTime = offsetTime
    }
    
    internal var jsonPayload: [String : Any] {
        return [
            JSONKeys.eventType.rawValue: eventType,
            JSONKeys.timestamp.rawValue: timestamp,
            JSONKeys.offsetTime.rawValue: offsetTime
        ]
    }
    
    internal enum JSONKeys: String {
        case eventType = "EventType"
        case timestamp = "Timestamp"
        case offsetTime = "OffsetTime"
    }
}
