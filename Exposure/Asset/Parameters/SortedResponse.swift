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
    public var sortDescriptors: [SortDescriptor]? {
        return sortDescription.descriptors
    }
    
    public func sort(on descriptors: [SortDescriptor]?) -> Self {
        var old = self
        old.sortDescription = SortDescription(descriptors: descriptors)
        return old
    }
    
    public func sort(on descriptor: SortDescriptor) -> Self {
        return sort(on: [descriptor])
    }
    
    public func sort(on key: String, ascending: Bool = true) -> Self {
        return sort(on: [SortDescriptor(key: key, ascending: ascending)])
    }
}

extension SortedResponse {
    public func thenSort(on descriptors: [SortDescriptor]) -> Self {
        if let previous = sortDescriptors {
            return sort(on: previous+descriptors)
        }
        else {
            return sort(on: descriptors)
        }
    }
    
    public func thenSort(on descriptor: SortDescriptor) -> Self {
        return thenSort(on: [descriptor])
    }
    
    public func thenSort(on key: String, ascending: Bool = true) -> Self {
        return thenSort(on: [SortDescriptor(key: key, ascending: ascending)])
    }
}

public struct SortDescription {
    internal let descriptors: [SortDescriptor]?
    
    internal init(descriptors: [SortDescriptor]? = nil) {
        self.descriptors = descriptors
    }
}

public struct SortDescriptor {
    public let key: String
    public let ascending: Bool
    
    public init(key: String, ascending: Bool = true) {
        self.key = key
        self.ascending = ascending
    }
}
