//
//  SortedResponse.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Defines sort description for an *Exposure request*.
public protocol SortedResponse {
    /// Sort description to apply
    var sortDescription: SortDescription { get set }
}

extension SortedResponse {
    /// Actice `SortDescriptor`s, if any.
    public var sortDescriptors: [SortDescriptor]? {
        return sortDescription.descriptors
    }
    
    /// Sort the response on these `SortDescriptor`s
    ///
    /// - parameter descriptors: sort order definition. Replaces any currently active `SortDescriptors` with 'descriptors'
    /// - returns: `Self`
    public func sort(on descriptors: [SortDescriptor]?) -> Self {
        var old = self
        old.sortDescription = SortDescription(descriptors: descriptors)
        return old
    }
    
    /// Sort the response on these `SortDescriptor`s
    ///
    /// - parameter descriptor: sort descriptor. Replaces any currently active `SortDescriptors` with 'descriptor'
    /// - returns: `Self`
    public func sort(on descriptor: SortDescriptor) -> Self {
        return sort(on: [descriptor])
    }
    
    /// Response will be sorted on `key` with the order defined by `ascending`
    ///
    /// - parameter key: key to sort on
    /// - parameter ascending: `true` will sort *ascending*, `false` *descending*
    /// - returns: `Self`
    public func sort(on key: String, ascending: Bool = true) -> Self {
        return sort(on: [SortDescriptor(key: key, ascending: ascending)])
    }
    
    /// Response will be sorted on `key`. Ascending order is default. Each `key` prefixed by a `-` character will ensure *descending* sort order on that key.
    ///
    /// - parameter keys: keys to sort on. Replaces any currently active `SortDescriptors`
    /// - returns: `Self`
    public func sort(on keys: [String]) -> Self {
        return sort(on: keys.flatMap{ SortDescriptor(regex: $0)} )
    }
}

extension SortedResponse {
    /// Adds `descriptors` to currently active `SortDescriptor`s
    ///
    /// - parameter descriptors: `SortDescriptor`s to append.
    /// - returns: `Self`
    public func thenSort(on descriptors: [SortDescriptor]) -> Self {
        if let previous = sortDescriptors {
            return sort(on: previous+descriptors)
        }
        else {
            return sort(on: descriptors)
        }
    }
    
    /// Adds `descriptor` to currently active `SortDescriptor`s
    ///
    /// - parameter descriptor: `SortDescriptor` to append.
    /// - returns: `Self`
    public func thenSort(on descriptor: SortDescriptor) -> Self {
        return thenSort(on: [descriptor])
    }
    
    /// Appends a `SortDescriptor` specified by `key` and `ascending` to currently active `SortDescriptor`s
    ///
    /// - parameter key: key to sort on
    /// - parameter ascending: `true` will sort *ascending*, `false` *descending*
    /// - returns: `Self`
    public func thenSort(on key: String, ascending: Bool = true) -> Self {
        return thenSort(on: [SortDescriptor(key: key, ascending: ascending)])
    }
    
    /// Appends `SortDescriptor`s specified by `key` to currently active `SortDescriptor`s. Each `key` prefixed by a `-` character will ensure *descending* sort order on that key.
    ///
    /// - parameter keys: keys to sort on
    /// - returns: `Self`
    public func thenSort(on keys: [String]) -> Self {
        return thenSort(on: keys.flatMap{ SortDescriptor(regex: $0)} )
    }
}

/// Stores a set of active `SortDescriptor`s.
public struct SortDescription {
    /// Actice `SortDescriptor`s, if any.
    internal let descriptors: [SortDescriptor]?
    
    internal init(descriptors: [SortDescriptor]? = nil) {
        self.descriptors = descriptors
    }
}

/// `SortDescriptor` defines a structure to manage individual sort options
public struct SortDescriptor {
    /// Key to sort on
    public let key: String
    
    /// Ascending or not
    public let ascending: Bool
    
    public init(key: String, ascending: Bool = true) {
        self.key = key
        self.ascending = ascending
    }
    
    internal init?(regex: String) {
        guard regex.count > 0 else { return nil }
        if regex.hasPrefix("-") {
            let index = regex.index(regex.startIndex, offsetBy: 1)
            let substring = regex.substring(from: index)
            guard substring.count > 0 else { return nil }
            self.key = substring
            self.ascending = false
        }
        else {
            self.key = regex
            self.ascending = true
        }
    }
}
