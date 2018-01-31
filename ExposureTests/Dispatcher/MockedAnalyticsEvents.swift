//
//  MockedAnalyticsEvents.swift
//  ExposureTests
//
//  Created by Fredrik Sjöberg on 2018-01-31.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import Exposure

struct Started: AnalyticsEvent {
    let eventType: String = "Playback.Started"
    let bufferLimit: Int64 = 3000
    let timestamp: Int64
    
    internal var jsonPayload: [String : Any] {
        return [
            JSONKeys.eventType.rawValue: eventType,
            JSONKeys.timestamp.rawValue: timestamp
        ]
    }
    
    internal enum JSONKeys: String {
        case eventType = "EventType"
        case timestamp = "Timestamp"
    }
}

struct Created: AnalyticsEvent {
    let eventType: String = "Playback.Created"
    let bufferLimit: Int64 = 3000
    let timestamp: Int64
    let version: String
    
    internal var jsonPayload: [String : Any] {
        return [
            JSONKeys.eventType.rawValue: eventType,
            JSONKeys.timestamp.rawValue: timestamp
        ]
    }
    
    internal enum JSONKeys: String {
        case eventType = "EventType"
        case timestamp = "Timestamp"
    }
}

struct Aborted: AnalyticsEvent {
    let eventType: String = "Playback.Aborted"
    let bufferLimit: Int64 = 2000
    let timestamp: Int64
    let offsetTime: Int64
    
    internal var jsonPayload: [String : Any] {
        return [
            JSONKeys.eventType.rawValue: eventType,
            JSONKeys.timestamp.rawValue: timestamp
        ]
    }
    
    internal enum JSONKeys: String {
        case eventType = "EventType"
        case timestamp = "Timestamp"
    }
}

struct Error: AnalyticsEvent {
    let eventType: String = "Playback.Aborted"
    let bufferLimit: Int64 = 3000
    let timestamp: Int64
    let offsetTime: Int64
    let code: Int64
    let message: String
    
    internal var jsonPayload: [String : Any] {
        return [
            JSONKeys.eventType.rawValue: eventType,
            JSONKeys.timestamp.rawValue: timestamp
        ]
    }
    
    internal enum JSONKeys: String {
        case eventType = "EventType"
        case timestamp = "Timestamp"
    }
}
