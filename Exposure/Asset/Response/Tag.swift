//
//  Tag.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Asset {
    public struct Tag {
        public let created: String?
        public let changed: String?
        public let type: String?
        public let tagValues: [Values]?
        
        public struct Values {
            public let tagId: String?
            
            public init?(json: Any) {
                let actualJson = JSON(json)
                tagId = actualJson[JSONKeys.tagId.rawValue].string
            }
            
            internal enum JSONKeys: String {
                case tagId = "tagId"
            }
        }
        
        public init?(json: Any) {
            let actualJson = JSON(json)
            created = actualJson[JSONKeys.created.rawValue].string
            changed = actualJson[JSONKeys.changed.rawValue].string
            type = actualJson[JSONKeys.type.rawValue].string
            tagValues = actualJson[JSONKeys.tagValues.rawValue].arrayObject?.flatMap{ Values(json: $0) }
        }
        
        internal enum JSONKeys: String {
            case created = "created"
            case changed = "changed"
            case type = "type"
            case tagValues = "tagValues"
        }
    }
}
