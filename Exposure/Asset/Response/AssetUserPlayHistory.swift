//
//  AssetUserPlayHistory.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct AssetUserPlayHistory: Decodable {
    /// Last viewed offset, offset in the last play of the asset.
    public let lastViewedOffset: Int
    
    /// Last viewed time, when the user last viewed the asset.
    public let lastViewedTime: Int
    
    /// The program id if the asset was viewed as catchup or live.
    public let programId: String?
    
    /// The program id if the asset was viewed as catchup or live.
    public let channelId: String?
}
