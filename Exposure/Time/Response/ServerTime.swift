//
//  ServerTime.swift
//  Exposure
//
//  Created by Hui Wang on 2017-04-04.
//  Copyright © 2017 emp. All rights reserved.
//

import SwiftyJSON

public struct ServerTime {
    public let epochMillis: UInt64?
    public let iso8601:String?
}

extension ServerTime: ExposureConvertible {
    public init?(json: JSON) {
        let actualJson = SwiftyJSON.JSON(json)
        
        epochMillis = actualJson[JSONKeys.epochMillis.rawValue].uInt64
        iso8601 = actualJson[JSONKeys.iso8601.rawValue].string
    }
    
    internal enum JSONKeys: String {
        case epochMillis = "epochMillis"
        case iso8601 = "iso8601"
    }
}
