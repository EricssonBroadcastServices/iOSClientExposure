//
//  Marker.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Marker {
    public let offset: Int?
    public let url: String?
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        
        offset = actualJson[JSONKeys.offset.rawValue].int
        url = actualJson[JSONKeys.url.rawValue].string
        
        if offset == nil && url == nil { return nil }
    }
    
    internal enum JSONKeys: String {
        case offset = "offset"
        case url = "url"
    }
}
