//
//  Program.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Program: ExposureConvertible {
    /// The date the program was created.
    public let created: String?
    
    /// The date the program was changed.
    public let changed: String?
    
    /// The id of the program.
    public let programId: String?
    
    /// The id of the asset this program is for.
    public let assetId: String?
    
    /// The id of the channel this program is on.
    public let channelId: String?
    
    /// Start time for the program
    public let startTime: String?
    
    /// End time for the program
    public let endTime: String?
    
    /// If this asset is currently available as VOD.
    public let vodAvailable: Bool?
    
    /// If this asset is currently available as rough cut that is not expired.
    public let catchup: Bool?
    
    /// If this asset is currently blocked for catchup.
    public let catchupBlocked: Bool?
    
    /// The asset metadata
    public let asset: Asset?
    
    // If this program is currently published as blackout. This means any publication contains blackout, not global blackout
    public let blackout: Bool?
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        
        created = actualJson[JSONKeys.created.rawValue].string
        changed = actualJson[JSONKeys.changed.rawValue].string
        programId = actualJson[JSONKeys.programId.rawValue].string
        assetId = actualJson[JSONKeys.assetId.rawValue].string
        channelId = actualJson[JSONKeys.channelId.rawValue].string
        startTime = actualJson[JSONKeys.startTime.rawValue].string
        endTime = actualJson[JSONKeys.endTime.rawValue].string
        vodAvailable = actualJson[JSONKeys.vodAvailable.rawValue].bool
        catchup = actualJson[JSONKeys.catchup.rawValue].bool
        catchupBlocked = actualJson[JSONKeys.catchupBlocked.rawValue].bool
        asset = Asset(json: actualJson[JSONKeys.asset.rawValue].object)
        blackout = actualJson[JSONKeys.blackout.rawValue].bool
        
        if (created == nil && changed == nil && programId == nil && assetId == nil &&  channelId == nil)
            && (startTime == nil && endTime == nil && vodAvailable == nil && catchup == nil)
            && (catchupBlocked == nil && asset == nil && blackout == nil) {
            return nil
        }
    }
    
    internal enum JSONKeys: String {
        case created = "created"
        case changed = "changed"
        case programId = "programId"
        case assetId = "assetId"
        case channelId = "channelId"
        case startTime = "startTime"
        case endTime = "endTime"
        case vodAvailable = "vodAvailable"
        case catchup = "catchup"
        case catchupBlocked = "catchupBlocked"
        case asset = "asset"
        case blackout = "blackout"
    }
}
