//
//  AnalyticsInitializationResponse.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct AnalyticsInitializationResponse {
    public let receivedTime: Int64?
    public let repliedTime: Int64?
    public let settings: AnalyticsConfigResponse?
}

extension AnalyticsInitializationResponse: ExposureConvertible {
    public init?(json: Any) {
        let actualJson = JSON(json)
        
        receivedTime = actualJson[JSONKeys.receivedTime.rawValue].int64
        repliedTime = actualJson[JSONKeys.repliedTime.rawValue].int64
        settings = AnalyticsConfigResponse(json: actualJson[JSONKeys.receivedTime.rawValue].object)
        
        if receivedTime == nil && repliedTime == nil && settings == nil { return nil }
    }
    
    internal enum JSONKeys: String {
        case receivedTime = "receivedTime"
        case repliedTime = "repliedTime"
        case settings = "settings"
    }
}
