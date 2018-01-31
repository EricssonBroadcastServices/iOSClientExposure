//
//  String+Extensions.swift
//  Analytics
//
//  Created by Fredrik Sjöberg on 2017-07-28.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

extension String {
    /// Generates a *sha256* hash from `self`
    internal var sha256Hash: Data? {
        return (self.data(using: .utf8) as NSData?)?.sha256Hash()
    }
}
