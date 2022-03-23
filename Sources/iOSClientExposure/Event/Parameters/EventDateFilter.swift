//
//  EventDates.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2019-09-16.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation

/// Defines an *Exposure Event request* date parameters.
public protocol FilteredEventDates {
    var eventDateFilter: EventDateFilter { get set }
}

/// Used internally to configure the event date filter
public struct EventDateFilter {
    
    /// Days backwards
    internal let daysBackward: Int64
    
    /// Days forward
    internal let daysForward: Int64
    
    internal init(daysBackward: Int64 = 0, daysForward: Int64 = 85) {
        self.daysBackward = daysBackward
        self.daysForward = daysForward
    }
}

extension FilteredEventDates {
    
    /// Filter the event in a date range
    ///
    /// - Parameters:
    ///   - daysBackward: days backward
    ///   - daysForward: days forward
    /// - Returns: `Self`
    public func filter(daysBackward: Int64 = 0, daysForward: Int64 = 85) -> Self {
        var old = self
        old.eventDateFilter = EventDateFilter(daysBackward: daysBackward,daysForward: daysForward )
        return old
    }
}
