//
//  PageableResponse.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-18.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public protocol PageableResponse {
    var pageFilter: PageFilter { get set }
}

extension PageableResponse {
    public var pageSize: Int {
        return pageFilter.size
    }
    
    public var pageNumber: Int {
        return pageFilter.page
    }
    
    public func show(page: Int, spanning items: Int = 50) -> Self {
        var old = self
        old.pageFilter = PageFilter(page: page, size: items)
        return old
    }
}

public struct PageFilter {
    internal let page: Int
    internal let size: Int
    
    internal init(page: Int = 1, size: Int = 50) {
        self.page = page
        self.size = size
    }
}
