//
//  FilteredDates.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public protocol FilteredDates {
    var dateFilter: DateFilter { get set }
}

extension FilteredDates {
    // MARK: AssetIds
    public var startDate: Date {
        return Date(milliseconds: dateFilter.startMillis)
    }
    
    public var endDate: Date {
        return Date(milliseconds: dateFilter.endMillis)
    }
    
    public func filter(starting: Date? = nil, ending: Date = Date()) -> Self {
        let startMillis = starting?.millisecondsSince1970 ?? 0
        var old = self
        old.dateFilter = DateFilter(start: startMillis,
                                    end: ending.millisecondsSince1970)
        return old
    }
    
    public func filter(starting: UInt64 = 0, ending: UInt64 = Date().millisecondsSince1970) -> Self {
        var old = self
        old.dateFilter = DateFilter(start: starting,
                                    end: ending)
        return old
    }
}

public struct DateFilter {
    internal let startMillis: UInt64
    internal let endMillis: UInt64
    
    internal init(start: UInt64, end: UInt64) {
        self.startMillis = start
        self.endMillis = end
    }
}
