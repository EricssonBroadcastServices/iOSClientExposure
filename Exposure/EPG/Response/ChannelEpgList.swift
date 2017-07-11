//
//  ChannelEpgList.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-10.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ChannelEpgList: ExposureConvertible {
    public let channels: [ChannelEpg]?
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        
        channels = actualJson.arrayObject?.flatMap{ ChannelEpg(json: $0) }
        
        if channels == nil { return nil }
    }
}
