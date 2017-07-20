//
//  EventSink.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct EventSink {
    public init() {
    }
}

extension EventSink {
    public func send(analytics batch: AnalyticsBatch) -> SendBatch {
        return SendBatch(messageBatch: batch)
    }
    
    public func initialize(using environment: Environment) -> EventSinkInit {
        return EventSinkInit(environment: environment)
    }
}
