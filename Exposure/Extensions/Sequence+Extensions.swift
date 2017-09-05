//
//  Sequence+Extensions.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

extension Sequence where Self.Iterator.Element: Hashable {
    /// Removes all duplicates in `Self`
    ///
    /// - important: Uses `Set` to force uniqueness. As such, sort order is no longer guaranteed to match input.
    internal func unique() -> [Self.Iterator.Element] {
        let set = Set(self)
        return Array(set)
    }
    
    /// Subtracts `other` Sequence from `Self` by performing `Set` subtraction.
    ///
    /// - important: This method uses `Set`s to do the subtraction. As such, any duplicates will be removed and the sort order is no longer guaranteed to match input.
    internal func subtract(_ other: Self) -> [Self.Iterator.Element] {
        let a = Set(self)
        let b = Set(other)
        return a.subtract(b)
    }
}

extension Array {
    /// Convenience method for combining two arrays
    ///
    /// - parameter lhs: left hand side array
    /// - parameter rhs: right hand side array
    /// - returns: merged array
    static func + (lhs: [Element], rhs: Element) -> [Element] {
        var old = lhs
        old.append(rhs)
        return old
    }
}
