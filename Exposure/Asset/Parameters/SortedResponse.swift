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
    
    /// Note: Replaces any currently active SortDescriptors 'descriptors'
    public func sort(on descriptors: [SortDescriptor]?) -> Self {
        var old = self
        old.sortDescription = SortDescription(descriptors: descriptors)
        return old
    }
    
    /// Note: Replaces any currently active SortDescriptors with 'descriptor'
    public func sort(on descriptor: SortDescriptor) -> Self {
        return sort(on: [descriptor])
    }
    
    /// Note: Replaces any currently active SortDescriptors with 'key'
    public func sort(on key: String, ascending: Bool = true) -> Self {
        return sort(on: [SortDescriptor(key: key, ascending: ascending)])
    }
    
    /// Note: Replaces any currently active SortDescriptors with 'keys' (using ascending sort order). Specifying a '-' prefix to a 'key' ensures descending sort order.
    public func sort(on keys: [String]) -> Self {
        return sort(on: keys.flatMap{ SortDescriptor(regex: $0)} )
    }
}

extension SortedResponse {
    /// Note: Adds 'descriptors' to currently active SortDescriptors
    public func thenSort(on descriptors: [SortDescriptor]) -> Self {
        if let previous = sortDescriptors {
            return sort(on: previous+descriptors)
        }
        else {
            return sort(on: descriptors)
        }
    }
    
    /// Note: Adds 'descriptor' to currently active SortDescriptors
    public func thenSort(on descriptor: SortDescriptor) -> Self {
        return thenSort(on: [descriptor])
    }
    
    /// Note: Adds 'key' to currently active SortDescriptors
    public func thenSort(on key: String, ascending: Bool = true) -> Self {
        return thenSort(on: [SortDescriptor(key: key, ascending: ascending)])
    }
    
    /// Note: Adds 'keys' (using ascending sort order) tp currently active SortDescriptors. Specifying a '-' prefix to a 'key' ensures descending sort order.
    public func thenSort(on keys: [String]) -> Self {
        return thenSort(on: keys.flatMap{ SortDescriptor(regex: $0)} )
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
    
    internal init?(regex: String) {
        guard regex.characters.count > 0 else { return nil }
        if regex.hasPrefix("-") {
            let index = regex.index(regex.startIndex, offsetBy: 1)
            let substring = regex.substring(from: index)
            guard substring.characters.count > 0 else { return nil }
            self.key = substring
            self.ascending = false
        }
        else {
            self.key = regex
            self.ascending = true
        }
    }
}
