//
//  PageableResponse.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-18.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Defines an *Exposure request* filter on the response size, effectively limiting the amount of data points returned.
public protocol PageableResponse {
    /// Filter to apply
    var pageFilter: PageFilter { get set }
}

extension PageableResponse {
    /// The page number
    public var pageSize: Int {
        return pageFilter.size
    }
    
    /// The number of items to show per page
    public var pageNumber: Int {
        return pageFilter.page
    }
    
    /// Request response data starting from `page` and spanning `items`.
    ///
    /// - parameter page: page number
    /// - parameter items: number of items to show per page
    /// - returns: `Self`
    public func show(page: Int, spanning items: Int = 50) -> Self {
        var old = self
        old.pageFilter = PageFilter(page: page, size: items)
        return old
    }
}

/// Used internally to configure the page filter
public struct PageFilter {
    /// The page number
    internal let page: Int
    
    /// The number of items to show per page
    internal let size: Int
    
    internal init(page: Int = 1, size: Int = 50) {
        self.page = page
        self.size = size
    }
}
