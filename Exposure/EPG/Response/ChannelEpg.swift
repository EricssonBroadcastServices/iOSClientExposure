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
public struct ChannelEpg: Decodable {
    /// Id of the requested channel
    public let channelId: String?
    
    /// Programs on the channel
    public let programs: [Program]?
    
    /// This is the total number of hits for all channels, not only this.
    public let totalHitsAllChannels: Int?
}
