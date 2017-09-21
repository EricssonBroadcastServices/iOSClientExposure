//
//  ChannelEpgList.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-10.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// `ChannelEpgList` response contains *EPG* information for a set of channels
public struct ChannelEpgList: Decodable {
    /// Channels with EPG data
    public let channels: [ChannelEpg]?
}
