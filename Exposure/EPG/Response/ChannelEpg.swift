//
//  ChannelEpg.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct ChannelEpg {
    public let channelId: String?
    public let programs: [Program]?
    public let totalHitsAllChannels: Int? //This is the total number of hits for all channels, not only this.
}
