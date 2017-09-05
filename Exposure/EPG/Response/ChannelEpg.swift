//
//  ChannelEpg.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

/// `ChannelEpgList` response contains *EPG* information for a set of channels.
public struct ChannelEpg: ExposureConvertible {
    /// Id of the requested channel
    public let channelId: String?
    
    /// Programs on the channel
    public let programs: [Program]?
    
    /// This is the total number of hits for all channels, not only this.
    public let totalHitsAllChannels: Int?
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        
        channelId = actualJson[JSONKeys.channelId.rawValue].string
        programs = actualJson[JSONKeys.programs.rawValue].arrayObject?.flatMap{ Program(json: $0) }
        totalHitsAllChannels = actualJson[JSONKeys.totalHitsAllChannels.rawValue].int
        
        if channelId == nil && programs == nil && totalHitsAllChannels == nil { return nil }
    }
    
    internal enum JSONKeys: String {
        case channelId = "channelId"
        case programs = "programs"
        case totalHitsAllChannels = "totalHitsAllChannels"
    }
}
