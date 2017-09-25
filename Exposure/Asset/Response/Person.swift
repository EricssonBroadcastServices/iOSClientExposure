//
//  Person.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Person: Decodable {
    /// Identifier for `Person`
    public let personId: String?
    
    /// Specified name
    public let name: String?
    
    /// Title, function or similair
    public let function: String?
}
