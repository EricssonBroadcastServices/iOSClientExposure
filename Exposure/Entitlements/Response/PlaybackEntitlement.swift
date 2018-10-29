//
//  PlaybackEntitlement.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-23.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// `PlaybackEntitlement`s contain all information required to configure and initiate `DRM` protected playback of an *asset* in the requested *format*.
public struct PlaybackEntitlement: Codable {
    // MARK: Required
    /// The expiration of the the play token. The player needs to be initialized and done the play call before this.
    public let playTokenExpiration: String
    
    /// The `URL` location for the media.
    public let mediaLocator: URL
    
    /// Unique id of this playback session, all analytics events for this session should be reported on with this id
    public let playSessionId: String
    
    /// If this is a live entitlement.
    public let live: Bool
    
    /// If fast forward is enabled
    public let ffEnabled: Bool
    
    /// If timeshift is disabled
    public let timeshiftEnabled: Bool
    
    /// If rewind is enabled
    public let rwEnabled: Bool
    
    /// If airplay is blocked
    public let airplayBlocked: Bool
    
    
    // MARK: Optional

    /// Play token to use for either PlayReady or MRR. Will be empty if the asset is unencrypted.
    public let playToken: String?
    
    /// The Fairplay specific configuration. Will be empty if the status is not SUCCESS or nor Fairplay configurations.
    public let fairplay: FairplayConfiguration?
    
    /// The datetime of expiration of the drm license.
    public let licenseExpiration: String?
    
    /// The reason of expiration of the drm license.
    ///
    ///     * SUCCESS: If the user is entitled
    ///     * NOT_ENTITLED: If the user is not entitled
    ///     * GEO_BLOCKED: If the user is in a country that is not allowed for the asset
    ///     * DOWNLOAD_BLOCKED: If downloading is not allowed
    ///     * DEVICE_BLOCKED: If the user device is not allowed to play the asset
    ///     * LICENSE_EXPIRED: If the asset has expired.
    ///     * NOT_AVAILABLE_IN_FORMAT: If there is not registered media for the asset in the format
    ///     * CONCURRENT_STREAMS_LIMIT_REACHED: If the maximum number of concurrent stream limit is reached
    ///     * NOT_ENABLED: If the media is registered but the current status is not enabled
    ///     * GAP_IN_EPG: If there is a gap in the Epg
    ///     * EPG_PLAY_MAX_HOURS:
    public let licenseExpirationReason: String?
    
    /// The datetime of activation of the drm license.
    public let licenseActivation: String?
    
    /// The type of entitlement that granted access to this play.
    ///
    ///     * TVOD
    ///     * SVOD
    ///     * FVOD
    public let entitlementType: String?
    
    /// Min bitrate to use
    public let minBitrate: Int64?
    
    /// Max bitrate to use
    public let maxBitrate: Int64?
    
    /// Max height resolution
    public let maxResHeight: Int?
    
    /// MDN Request Router Url
    public let mdnRequestRouterUrl: String?
    
    /// Last viewed offset.
    public let lastViewedOffset: Int?
    
    /// Last viewed time
    public let lastViewedTime: Int64?
    
    /// Live timestamp
    public let liveTime: Int64?
    
    /// Identity of the product that permitted playback of the asset
    public let productId: String?
    
    /// Optional `URL` for streams supporting serverside ad insertion.
    public let adMediaLocator: URL?
}

extension PlaybackEntitlement {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Required
        playTokenExpiration = try container.decode(String.self, forKey: .playTokenExpiration)
        mediaLocator = try container.decode(URL.self, forKey: .mediaLocator)
        playSessionId = try container.decode(String.self, forKey: .playSessionId)
        
        live = try container.decode(Bool.self, forKey: .live)
        ffEnabled = try container.decode(Bool.self, forKey: .ffEnabled)
        timeshiftEnabled = try container.decode(Bool.self, forKey: .timeshiftEnabled)
        rwEnabled = try container.decode(Bool.self, forKey: .rwEnabled)
        airplayBlocked = try container.decode(Bool.self, forKey: .airplayBlocked)
        
        // Optional
        playToken = try container.decodeIfPresent(String.self, forKey: .playToken)
        fairplay = try container.decodeIfPresent(FairplayConfiguration.self, forKey: .fairplay)
        
        licenseExpiration = try container.decodeIfPresent(String.self, forKey: .licenseExpiration)
        licenseExpirationReason = try container.decodeIfPresent(String.self, forKey: .licenseExpirationReason)
        licenseActivation = try container.decodeIfPresent(String.self, forKey: .licenseActivation)
        
        entitlementType = try container.decodeIfPresent(String.self, forKey: .entitlementType)
        
        minBitrate = try container.decodeIfPresent(Int64.self, forKey: .minBitrate)
        maxBitrate = try container.decodeIfPresent(Int64.self, forKey: .maxBitrate)
        maxResHeight = try container.decodeIfPresent(Int.self, forKey: .maxResHeight)
        
        mdnRequestRouterUrl = try container.decodeIfPresent(String.self, forKey: .mdnRequestRouterUrl)
        lastViewedOffset = try container.decodeIfPresent(Int.self, forKey: .lastViewedOffset)
        lastViewedTime = try container.decodeIfPresent(Int64.self, forKey: .lastViewedTime)
        liveTime = try container.decodeIfPresent(Int64.self, forKey: .liveTime)
        productId = try container.decodeIfPresent(String.self, forKey: .productId)
        adMediaLocator = try container.decodeIfPresent(URL.self, forKey: .adMediaLocator)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(playTokenExpiration, forKey: .playTokenExpiration)
        try container.encode(mediaLocator, forKey: .mediaLocator)
        try container.encode(playSessionId, forKey: .playSessionId)
        
        try container.encode(live, forKey: .live)
        try container.encode(ffEnabled, forKey: .ffEnabled)
        try container.encode(timeshiftEnabled, forKey: .timeshiftEnabled)
        try container.encode(rwEnabled, forKey: .rwEnabled)
        try container.encode(airplayBlocked, forKey: .airplayBlocked)
        
        try container.encodeIfPresent(playToken, forKey: .playToken)
        try container.encodeIfPresent(fairplay, forKey: .fairplay)
        
        try container.encodeIfPresent(licenseExpiration, forKey: .licenseExpiration)
        try container.encodeIfPresent(licenseExpirationReason, forKey: .licenseExpirationReason)
        try container.encodeIfPresent(licenseActivation, forKey: .licenseActivation)
        
        try container.encodeIfPresent(entitlementType, forKey: .entitlementType)
        
        try container.encodeIfPresent(minBitrate, forKey: .minBitrate)
        try container.encodeIfPresent(maxBitrate, forKey: .maxBitrate)
        try container.encodeIfPresent(maxResHeight, forKey: .maxResHeight)
        
        try container.encodeIfPresent(mdnRequestRouterUrl, forKey: .mdnRequestRouterUrl)
        try container.encodeIfPresent(lastViewedOffset, forKey: .lastViewedOffset)
        try container.encodeIfPresent(lastViewedTime, forKey: .lastViewedTime)
        try container.encodeIfPresent(liveTime, forKey: .liveTime)
        try container.encodeIfPresent(productId, forKey: .productId)
        try container.encodeIfPresent(adMediaLocator, forKey: .adMediaLocator)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case playToken
        case fairplay = "fairplayConfig"
        case mediaLocator
        case licenseExpiration
        case licenseExpirationReason
        case licenseActivation
        case playTokenExpiration
        case entitlementType
        case live
        case playSessionId
        case ffEnabled
        case timeshiftEnabled
        case rwEnabled
        case minBitrate
        case maxBitrate
        case maxResHeight
        case airplayBlocked
        case mdnRequestRouterUrl
        case lastViewedOffset
        case lastViewedTime
        case liveTime
        case productId
        case adMediaLocator
    }
}
