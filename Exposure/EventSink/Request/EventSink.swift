//
//  EventSink.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct EventSink {
    /// Exposure environment
    public let environment: Environment
    
    public init(environment: Environment) {
        self.environment = environment
    }
}
