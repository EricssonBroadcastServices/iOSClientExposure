//
//  EventSink.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Drop-off point for *Exposure* based analytics.
public struct EventSink {
    public init() { }
}

extension EventSink {
    /// `AnalyticsBatch`es are self contained and can thus be delivered *as-is*.
    ///
    /// - parameter batch: Analytics batch to deliver
    /// - parameter clockOffset: Estimated offset between the device clock and the server clock, in milliseconds. A positive value means that the device is ahead of the server.
    /// - returns: `SendBatch` struct used to process the request.
    public func send(analytics batch: AnalyticsBatch, clockOffset: Int64?) -> SendBatch {
        return SendBatch(messageBatch: batch, clockOffset: clockOffset)
    }
    
    /// `EventSink` Initialization returns a set of basic data used to configure the *Analytics Environment*
    ///
    /// - parameter environment: *Exposure* environment
    /// - returns: `EventSinkInit` struct used to process the request.
    public func initialize(using environment: Environment) -> EventSinkInit {
        return EventSinkInit(environment: environment)
    }
}
