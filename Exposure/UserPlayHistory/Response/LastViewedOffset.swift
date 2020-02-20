//
//  ViewedOffset.swift
//  Exposure-iOS
//
//  Created by Johnny Sundblom on 2020-02-17.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

public struct LastViewedOffset: Codable {
    public let assetId: String?
    /// The program id if the asset was viewed as catchup or live.
    public let channelId: String?
    
    /// Last viewed offset, offset in the last play of the asset.
    public let lastViewedOffset: Int?
    
    /// Last viewed time, when the user last viewed the asset.
    public let lastViewedTime: Int64?
    
    ///
    public let liveTime: Int64?
    
    /// The program id if the asset was viewed as catchup or live.
    public let programId: String?
    
    
}

