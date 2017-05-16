//
//  ExternalReference.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Asset {
    public struct ExternalReference {
        public let locator: String?
        public let type: String?
        public let value: String?
        
        public init?(json: Any) {
            let actualJson = JSON(json)
            locator = actualJson[JSONKeys.locator.rawValue].string
            type = actualJson[JSONKeys.type.rawValue].string
            value = actualJson[JSONKeys.value.rawValue].string
            
            if locator == nil && type == nil && value == nil { return nil }
        }
        
        internal enum JSONKeys: String {
            case locator = "locator"
            case type = "type"
            case value = "value"
        }
    }
}
