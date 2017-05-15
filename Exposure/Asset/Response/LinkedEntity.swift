//
//  LinkedEntity.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Asset {
    public struct LinkedEntity {
        public let entityId: String?
        public let linkType: String?
        public let entityType: String?
        
        public init?(json: Any) {
            let actualJson = JSON(json)
            entityId = actualJson[JSONKeys.entityId.rawValue].string
            linkType = actualJson[JSONKeys.linkType.rawValue].string
            entityType = actualJson[JSONKeys.entityType.rawValue].string
        }
        
        internal enum JSONKeys: String {
            case entityId = "entityId"
            case linkType = "linkType"
            case entityType = "entityType"
        }
    }
}
