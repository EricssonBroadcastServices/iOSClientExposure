//
//  FetchEvent.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2019-09-16.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation


/// *Exposure* request for fetching *Event*.
public struct FetchEvent {
    /// `Environment` to use
    public let environment: Environment
    
    public init(environment: Environment) {
        self.environment = environment
    }
}

extension FetchEvent {
    
    /// Fetches all the live events
    ///
    /// - returns: `FetchEventList` struct used to process the request.
    public func list(date: String) -> FetchEventList {
        return FetchEventList(environment: environment, date: date)
    }
}
