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
    
    /// Filter assets between specific dates (EPG) based on a set referance date. The difference between reference date and start/end date will be taken into account based on a number of days.
    ///
    /// - parameter startDate: The range start date. If the start date is newer than the reference date then the referece date is taken.
    /// - parameter endDate: The range end date. If the end date is older than the reference date then the referece date is taken.
    /// - returns: `Self`
    public func filter(
        startDate: Date = Date(),
        endDate: Date = Date()
    ) -> Self {
        var old = self
        old.dateFilter = DateFilter(
            startDate: startDate,
            endDate: endDate
        )
        return old
    }
}

/// Used internally to configure the date filter
public struct DateFilter {
    /// Start date in unix epoch time (milliseconds)
    internal let startMillis: Int64
    
    /// End date in unix epoch time (milliseconds)
    internal let endMillis: Int64
    
    /// Start range date
    internal let startDate: Date
    
    /// Start range date 
    internal let endDate: Date
    
    internal init(
        start: Int64 = 0,
        end: Int64 = Date().millisecondsSince1970,
        startDate: Date =  Date(),
        endDate: Date = Date()
    ) {
        self.startMillis = start
        self.endMillis = end
        self.startDate = startDate
        self.endDate = endDate
    }
    
    public func daysForward(
        date: Date = Date()
    ) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date, to: endDate)
        return components.day ?? 0
    }
    
    public func daysBackward(
        date: Date = Date()
    ) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: date)
        return components.day ?? 0
    }
}
