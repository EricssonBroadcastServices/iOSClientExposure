//
//  FilteredPublish.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-18.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public protocol FilteredPublish {
    var publishFilter: PublishFilter { get set }
}

extension FilteredPublish {
    // MARK: Published
    public var onlyPublished: Bool {
        return publishFilter.onlyPublished
    }
    public func filter(onlyPublished: Bool) -> Self {
        var old = self
        old.publishFilter = PublishFilter(onlyPublished: onlyPublished)
        return old
    }
}

public struct PublishFilter {
    internal let onlyPublished: Bool
    
    internal init(onlyPublished: Bool = true) {
        self.onlyPublished = onlyPublished
    }
}
