//
//  SortedResponse.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public protocol SortedResponse {
    var sortDescription: SortDescription { get set }
}

extension SortedResponse {
    public func sort(on descriptors: [SortDescriptor]) -> Self {
        var old = self
        old.sortDescription = SortDescription(descriptors: descriptors)
        return old
    }
    
    public func sort(on descriptor: SortDescriptor) -> Self {
        var old = self
        old.sortDescription = SortDescription(descriptors: [descriptor])
        return old
    }
    
    public func sort(on key: String, ascending: Bool = true) -> Self {
        let descriptor = SortDescriptor(key: key, ascending: ascending)
        var old = self
        old.sortDescription = SortDescription(descriptors: [descriptor])
        return old
    }
}

extension SortedResponse {
    public func thenSort(on descriptors: [SortDescriptor]) -> Self {
        var old = self
        old.sortDescription = SortDescription(descriptors: sortDescription.descriptors+descriptors)
        return old
    }
    
    public func thenSort(on descriptor: SortDescriptor) -> Self {
        var old = self
        old.sortDescription = SortDescription(descriptors: sortDescription.descriptors+descriptor)
        return old
    }
    
    public func thenSort(on key: String, ascending: Bool = true) -> Self {
        let descriptor = SortDescriptor(key: key, ascending: ascending)
        var old = self
        old.sortDescription = SortDescription(descriptors: sortDescription.descriptors+descriptor)
        return old
    }
}

public struct SortDescription {
    internal let descriptors: [SortDescriptor]
}

public struct SortDescriptor {
    public let key: String
    public let ascending: Bool
    
    public init(key: String, ascending: Bool = true) {
        self.key = key
        self.ascending = ascending
    }
}
