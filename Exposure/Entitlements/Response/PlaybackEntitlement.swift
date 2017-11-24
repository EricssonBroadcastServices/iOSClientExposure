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
    
    /// The EDRM specific configuration. Will be empty if the status is not SUCCESS.
    public let edrm: EDRMConfiguration?
    
    /// The Fairplay specific configuration. Will be empty if the status is not SUCCESS or nor Fairplay configurations.
    public let fairplay: FairplayConfiguration?
    
    /// The datetime of expiration of the drm license.
    public let licenseExpiration: String?
    
    ///The reason of expiration of the drm license.
    public let licenseExpirationReason: Status?
    
    /// The datetime of activation of the drm license.
    public let licenseActivation: String?
    
    /// The type of entitlement that granted access to this play.
    public let entitlementType: EntitlementType?
    
    /// Min bitrate to use
    public let minBitrate: Int?
    
    /// Max bitrate to use
    public let maxBitrate: Int?
    
    /// Max height resolution
    public let maxResHeight: Int?
    
    /// MDN Request Router Url
    public let mdnRequestRouterUrl: String?
    
    /// Last viewed offset. Used by *Session Shift*
    public let lastViewedOffset: Int?
    
    /// Identity of the product that permitted playback of the asset
    public let productId: String?
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
        edrm = try container.decodeIfPresent(EDRMConfiguration.self, forKey: .edrm)
        fairplay = try container.decodeIfPresent(FairplayConfiguration.self, forKey: .fairplay)
        
        licenseExpiration = try container.decodeIfPresent(String.self, forKey: .licenseExpiration)
        licenseExpirationReason = Status(string: try container.decodeIfPresent(String.self, forKey: .licenseExpirationReason))
        licenseActivation = try container.decodeIfPresent(String.self, forKey: .licenseActivation)
        
        entitlementType = EntitlementType(string: try container.decodeIfPresent(String.self, forKey: .entitlementType))
        
        minBitrate = try container.decodeIfPresent(Int.self, forKey: .minBitrate)
        maxBitrate = try container.decodeIfPresent(Int.self, forKey: .maxBitrate)
        maxResHeight = try container.decodeIfPresent(Int.self, forKey: .maxResHeight)
        
        mdnRequestRouterUrl = try container.decodeIfPresent(String.self, forKey: .mdnRequestRouterUrl)
        lastViewedOffset = try container.decodeIfPresent(Int.self, forKey: .lastViewedOffset)
        productId = try container.decodeIfPresent(String.self, forKey: .productId)
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
        try container.encodeIfPresent(edrm, forKey: .edrm)
        try container.encodeIfPresent(fairplay, forKey: .fairplay)
        
        try container.encodeIfPresent(licenseExpiration, forKey: .licenseExpiration)
        try container.encodeIfPresent(licenseExpirationReason?.encodableValue, forKey: .licenseExpirationReason)
        try container.encodeIfPresent(licenseActivation, forKey: .licenseActivation)
        
        try container.encodeIfPresent(entitlementType?.encodableValue, forKey: .entitlementType)
        
        try container.encodeIfPresent(minBitrate, forKey: .minBitrate)
        try container.encodeIfPresent(maxBitrate, forKey: .maxBitrate)
        try container.encodeIfPresent(maxResHeight, forKey: .maxResHeight)
        
        try container.encodeIfPresent(mdnRequestRouterUrl, forKey: .mdnRequestRouterUrl)
        try container.encodeIfPresent(lastViewedOffset, forKey: .lastViewedOffset)
        try container.encodeIfPresent(productId, forKey: .productId)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case playToken
        case edrm = "edrmConfig"
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
        case productId
    }
}

extension PlaybackEntitlement {
    
    /// Details the `PlaybackEntitlement`s *license* status
    public enum Status: Equatable {
        /// If the user is entitled.
        case success
        
        /// If the user is not entitled.
        case notEntitled
        
        /// If the user is in a country that is not allowed for the country.
        case geoBlocked
        
        case downloadBlocked
        
        ///  If the user device is not allowed to play the asset.
        case deviceBlocked
        
        /// If the asset has expired.
        case licenseExpired
        
        /// If there is not registered media for the asset in the format.
        case notAvailableInFormat
        
        /// If the maximum number of concurrent stream limit is reached.
        case concurrentStreamsLimitReached
        
        /// If the media is registered but the current status is not enabled
        case notEnabled
        
        case gapInEPG
        case epgPlayMaxHours
        case other(reason: String)
        
        internal init?(string: String?) {
            guard let value = string else { return nil }
            self = Status(string: value)
        }
        
        internal init(string: String) {
            switch string {
            case "SUCCESS": self = .success
            case "NOT_ENTITLED": self = .notEntitled
            case "GEO_BLOCKED": self = .geoBlocked
            case "DOWNLOAD_BLOCKED": self = .downloadBlocked
            case "DEVICE_BLOCKED": self = .deviceBlocked
            case "LICENSE_EXPIRED": self = .licenseExpired
            case "NOT_AVAILABLE_IN_FORMAT": self = .notAvailableInFormat
            case "CONCURRENT_STREAMS_LIMIT_REACHED": self = .concurrentStreamsLimitReached
            case "NOT_ENABLED": self = .notEnabled
            case "GAP_IN_EPG": self = .gapInEPG
            case "EPG_PLAY_MAX_HOURS": self = .epgPlayMaxHours
            default: self = .other(reason: string)
            }
        }
        
        internal var encodableValue: String {
            switch self {
            case .success: return "SUCCESS"
            case .notEntitled: return "NOT_ENTITLED"
            case .geoBlocked: return "GEO_BLOCKED"
            case .downloadBlocked: return "DOWNLOAD_BLOCKED"
            case .deviceBlocked: return "DEVICE_BLOCKED"
            case .licenseExpired: return "LICENSE_EXPIRED"
            case .notAvailableInFormat: return "NOT_AVAILABLE_IN_FORMAT"
            case .concurrentStreamsLimitReached: return "CONCURRENT_STREAMS_LIMIT_REACHED"
            case .notEnabled: return "NOT_ENABLED"
            case .gapInEPG: return "GAP_IN_EPG"
            case .epgPlayMaxHours: return "EPG_PLAY_MAX_HOURS"
            case .other(reason: let string): return string
            }
        }
        
        public static func == (lhs: Status, rhs: Status) -> Bool {
            switch (lhs, rhs) {
            case (.success, .success): return true
            case (.notEntitled, .notEntitled): return true
            case (.geoBlocked, .geoBlocked): return true
            case (.downloadBlocked, .downloadBlocked): return true
            case (.deviceBlocked, .deviceBlocked): return true
            case (.licenseExpired, .licenseExpired): return true
            case (.notAvailableInFormat, .notAvailableInFormat): return true
            case (.concurrentStreamsLimitReached, .concurrentStreamsLimitReached): return true
            case (.notEnabled, .notEnabled): return true
            case (.gapInEPG, .gapInEPG): return true
            case (.epgPlayMaxHours, .epgPlayMaxHours): return true
            case (.other(let l), .other(let r)): return l == r
            default: return false
            }
        }
    }
}

extension PlaybackEntitlement {
    public enum EntitlementType {
        case tvod
        case svod
        case fvod
        case other(type: String)
        
        
        internal init?(string: String?) {
            guard let value = string else { return nil }
            self = EntitlementType(string: value)
        }
        
        internal init(string: String) {
            switch string {
            case "TVOD": self = .tvod
            case "SVOD": self = .svod
            case "FVOD": self = .fvod
            default: self = .other(type: string)
            }
        }
        
        internal var encodableValue: String {
            switch self {
            case .tvod: return "TVOD"
            case .svod: return "SVOD"
            case .fvod: return "FVOD"
            case .other(type: let string): return string
            }
        }
    }
}
