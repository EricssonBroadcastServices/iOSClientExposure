//
//  AssetRights.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct AssetRights {
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
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        minBitrate = actualJson[JSONKeys.minBitrate.rawValue].int
        maxBitrate = actualJson[JSONKeys.maxBitrate.rawValue].int
        maxResWidth = actualJson[JSONKeys.maxResWidth.rawValue].int
        maxResHeight = actualJson[JSONKeys.maxResHeight.rawValue].int
        playCount = actualJson[JSONKeys.playCount.rawValue].int
        maxFileSize = actualJson[JSONKeys.maxFileSize.rawValue].int
        
        activation = actualJson[JSONKeys.activation.rawValue].string
        expiration = actualJson[JSONKeys.expiration.rawValue].string
        
        maxAds = actualJson[JSONKeys.maxAds.rawValue].int
        
        wifiBlocked = actualJson[JSONKeys.wifiBlocked.rawValue].bool
        threeGBlocked = actualJson[JSONKeys.threeGBlocked.rawValue].bool
        fourGBlocked = actualJson[JSONKeys.fourGBlocked.rawValue].bool
        HDMIBlocked = actualJson[JSONKeys.HDMIBlocked.rawValue].bool
        airplayBlocked = actualJson[JSONKeys.airplayBlocked.rawValue].bool
        downloadBlocked = actualJson[JSONKeys.downloadBlocked.rawValue].bool
        streamingBlocked = actualJson[JSONKeys.streamingBlocked.rawValue].bool
        analyticsEnabled = actualJson[JSONKeys.analyticsEnabled.rawValue].bool
        sessionShiftEnabled = actualJson[JSONKeys.wifiBlocked.rawValue].bool
        rwEnabled = actualJson[JSONKeys.rwEnabled.rawValue].bool
        ffEnabled = actualJson[JSONKeys.ffEnabled.rawValue].bool
        amcDebugLogEnabled = actualJson[JSONKeys.amcDebugLogEnabled.rawValue].bool
        locationEnabled = actualJson[JSONKeys.locationEnabled.rawValue].bool
        
        minPlayPosition = actualJson[JSONKeys.minPlayPosition.rawValue].int
        maxPlayPosition = actualJson[JSONKeys.maxPlayPosition.rawValue].int
        
        jailbrokenBlocked = actualJson[JSONKeys.jailbrokenBlocked.rawValue].bool
        
        downloadMaxSecondsAfterDownload = actualJson[JSONKeys.downloadMaxSecondsAfterDownload.rawValue].int
        downloadMaxSecondsAfterPlay = actualJson[JSONKeys.downloadMaxSecondsAfterPlay.rawValue].int
        
        if minBitrate == nil && maxBitrate == nil && maxResHeight == nil && maxResWidth == nil
            && playCount == nil && maxFileSize == nil && activation == nil && expiration == nil
            && maxAds == nil && wifiBlocked == nil && threeGBlocked == nil && fourGBlocked == nil
            && HDMIBlocked == nil && airplayBlocked == nil && downloadBlocked == nil && streamingBlocked == nil
            && analyticsEnabled == nil && sessionShiftEnabled == nil && rwEnabled == nil
            && ffEnabled == nil  && amcDebugLogEnabled == nil && locationEnabled == nil
            && minPlayPosition == nil && maxPlayPosition == nil && jailbrokenBlocked == nil
            && downloadMaxSecondsAfterDownload == nil && downloadMaxSecondsAfterPlay == nil {
            return nil
        }
    }
    
    internal enum JSONKeys: String {
        case minBitrate = "minBitrate"
        case maxBitrate = "maxBitrate"
        case maxResWidth = "maxResWidth"
        case maxResHeight = "maxResHeight"
        case playCount = "playCount"
        case maxFileSize = "maxFileSize"
        case activation = "activation"
        case expiration = "expiration"
        case maxAds = "maxAds"
        case wifiBlocked = "wifiBlocked"
        case threeGBlocked = "threeGBlocked"
        case fourGBlocked = "fourGBlocked"
        case HDMIBlocked = "HDMIBlocked"
        case airplayBlocked = "airplayBlocked"
        case downloadBlocked = "downloadBlocked"
        case streamingBlocked = "streamingBlocked"
        case analyticsEnabled = "analyticsEnabled"
        case sessionShiftEnabled = "sessionShiftEnabled"
        case rwEnabled = "rwEnabled"
        case ffEnabled = "ffEnabled"
        case amcDebugLogEnabled = "amcDebugLogEnabled"
        case locationEnabled = "locationEnabled"
        case minPlayPosition = "minPlayPosition"
        case maxPlayPosition = "maxPlayPosition"
        case jailbrokenBlocked = "jailbrokenBlocked"
        case downloadMaxSecondsAfterDownload = "downloadMaxSecondsAfterDownload"
        case downloadMaxSecondsAfterPlay = "downloadMaxSecondsAfterPlay"
    }
}
