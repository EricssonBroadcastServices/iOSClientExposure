//
//  AnalyticsEvent.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Defines the `json` payload loadable into an `AnalyticsBatch`
public protocol AnalyticsPayload {
    var jsonPayload: [String: Any] { get }
}

/// `AnalyticsEvent` is the basic building block of *EMP* specific analytics data.
public protocol AnalyticsEvent: AnalyticsPayload {
    /// The type of event
    /// Example: Playback.Created
    var eventType: String { get }
    
    /// Unix timestamp according to device clock when the event was trigged in milliseconds
    var timestamp: Int64 { get }
    
    /// Max time in milliseconds the event is kept in the batch before it should be flushed.
    var bufferLimit: Int64 { get }
}
