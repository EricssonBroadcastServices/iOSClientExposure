//
//  ChannelEpgList.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-10.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON


/// `ChannelEpgList` response contains *EPG* information for a set of channels
public struct ChannelEpgList: ExposureConvertible {
    /// Channels with EPG data
    public let channels: [ChannelEpg]?
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        
        channels = actualJson.arrayObject?.flatMap{ ChannelEpg(json: $0) }
        
        if channels == nil { return nil }
    }
}
