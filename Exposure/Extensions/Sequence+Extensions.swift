//
//  Sequence+Extensions.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

extension Sequence where Self.Iterator.Element: Hashable {
    internal func unique() -> [Self.Iterator.Element] {
        let set = Set(self)
        return Array(set)
    }
    
    internal func subtract(_ other: Self) -> [Self.Iterator.Element] {
        let a = Set(self)
        let b = Set(other)
        return a.subtract(b)
    }
}
