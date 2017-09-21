//
//  AssetRights.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct AssetRights: Decodable {
    /// Minimum bitrate allowed
    public let minBitrate: Int?
    
    /// Maximum bitrate allowed
    public let maxBitrate: Int?
    
    /// Maximum resolution width allowed
    public let maxResWidth: Int?
    
    /// Maximum resolution height allowed
    public let maxResHeight: Int?
    
    
    public let playCount: Int?
    public let maxFileSize: Int?
    
    public let activation: String?
    public let expiration: String?
    
    public let maxAds: Int?
    
    /// If wifi access is blocked
    public let wifiBlocked: Bool?
    
    /// If 3G access is blocked
    public let threeGBlocked: Bool?
    
    /// If 4G access is blocked
    public let fourGBlocked: Bool?
    
    /// If HDMI playback is blocked
    public let HDMIBlocked: Bool?
    
    /// If Airplay is blocked
    public let airplayBlocked: Bool?
    
    /// If download is blocked
    public let downloadBlocked: Bool?
    
    /// If streaming is blocked
    public let streamingBlocked: Bool?
    
    /// Is Analytics required to be enabled
    public let analyticsEnabled: Bool?
    
    /// If session shift is allowed
    public let sessionShiftEnabled: Bool?
    
    /// If rewind is allowed
    public let rwEnabled: Bool?
    
    /// If fast forward is allowed
    public let ffEnabled: Bool?
    
    public let amcDebugLogEnabled: Bool?
    public let locationEnabled: Bool?
    
    /// Minimum allowed playback positon
    public let minPlayPosition: Int?
    
    /// Maximum allowed playback position
    public let maxPlayPosition: Int?
    
    /// If jailbroken devices are blocked
    public let jailbrokenBlocked: Bool?
    
    public let downloadMaxSecondsAfterDownload: Int?
    public let downloadMaxSecondsAfterPlay: Int?
}
