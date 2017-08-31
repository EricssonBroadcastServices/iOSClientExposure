//
//  Person.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Person {
    /// Identifier for `Person`
    public let personId: String?
    
    /// Specified name
    public let name: String?
    
    /// Title, function or similair
    public let function: String?
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        personId = actualJson[JSONKeys.personId.rawValue].string
        name = actualJson[JSONKeys.name.rawValue].string
        function = actualJson[JSONKeys.function.rawValue].string
        
        if personId == nil && name == nil && function == nil { return nil }
    }
    
    internal enum JSONKeys: String {
        case personId = "personId"
        case name = "name"
        case function = "function"
    }
}
