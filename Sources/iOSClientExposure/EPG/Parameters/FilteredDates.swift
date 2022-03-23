//
//  FilteredDates.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Defines an *Exposure request* filter on dates.
public protocol FilteredDates {
    var dateFilter: DateFilter { get set }
}

extension FilteredDates {
    /// Include assets after `startDate`
    public var startDate: Date {
        return Date(milliseconds: dateFilter.startMillis)
    }
    
    /// Include assets up until `endDate`
    public var endDate: Date {
        return Date(milliseconds: dateFilter.endMillis)
    }
    
    /// Filter assets only in the specified range (`Date`s)
    ///
    /// - parameter starting: The starting date. `nil` specifies no starting date
    /// - parameter ending: The ending date. Default value is the current device date.
    /// - returns: `Self`
    public func filter(starting: Date? = nil, ending: Date = Date()) -> Self {
        let startMillis = starting?.millisecondsSince1970 ?? 0
        var old = self
        old.dateFilter = DateFilter(start: startMillis,
                                    end: ending.millisecondsSince1970)
        return old
    }
    
    /// Filter assets only in the specified range (in *unix epoch* time)
    ///
    /// - parameter starting: The starting timestamp, in milliseconds unix epoch time. Default is 0
    /// - parameter ending: The ending timestamp, in milliseconds unix epoch time. Default is the current device date.
    /// - returns: `Self`
    public func filter(starting: Int64 = 0, ending: Int64 = Date().millisecondsSince1970) -> Self {
        var old = self
        old.dateFilter = DateFilter(start: starting,
                                    end: ending)
        return old
    }
}

/// Used internally to configure the date filter
public struct DateFilter {
    /// Start date in unix epoch time (milliseconds)
    internal let startMillis: Int64
    
    /// End date in unix epoch time (milliseconds)
    internal let endMillis: Int64
    
    internal init(start: Int64 = 0, end: Int64 = Date().millisecondsSince1970) {
        self.startMillis = start
        self.endMillis = end
    }
}
