//
//  AnalyticsEvent.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// `AnalyticsEvent` is the basic building block of *EMP* specific analytics data.
public protocol AnalyticsEvent {
    /// The type of event
    /// Example: Playback.Created
    var eventType: String { get }
    
    /// Unix timestamp according to device clock when the event was trigged in milliseconds
    var timestamp: Int64 { get }
    
    /// Max time in milliseconds the event is kept in the batch before it should be flushed.
    var bufferLimit: Int64 { get }
    
    var jsonPayload: [String: Any] { get }
}

extension AnalyticsEvent {
    /// Defines how long an event can be kept in a batch before it has to be dispatched. This relates to the *realtime* aspect of the analytics engine.
    var bufferLimit: Int64 {
        return 3000
    }
}
