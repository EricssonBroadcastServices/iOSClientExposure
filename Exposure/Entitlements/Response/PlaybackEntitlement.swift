//
//  PlaybackEntitlement.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-23.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// `PlaybackEntitlement`s contain all information required to configure and initiate `DRM` protected playback of an *asset* in the requested *format*.
public struct PlaybackEntitlement {
    // MARK: Required
    /// Play token to use for either PlayReady or MRR.
    public let playToken: String
    
    /// The expiration of the the play token. The player needs to be initialized and done the play call before this.
    public let playTokenExpiration: String
    
    /// The information needed to locate the media. FOR EDRM this will be the media uid, for other formats it's the URL of the media.
    public let mediaLocator: String
    
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

extension PlaybackEntitlement: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Required
        playToken = try container.decode(String.self, forKey: .playToken)
        playTokenExpiration = try container.decode(String.self, forKey: .playTokenExpiration)
        mediaLocator = try container.decode(String.self, forKey: .mediaLocator)
        playSessionId = try container.decode(String.self, forKey: .playSessionId)
        
        live = try container.decode(Bool.self, forKey: .live)
        ffEnabled = try container.decode(Bool.self, forKey: .ffEnabled)
        timeshiftEnabled = try container.decode(Bool.self, forKey: .timeshiftEnabled)
        rwEnabled = try container.decode(Bool.self, forKey: .rwEnabled)
        airplayBlocked = try container.decode(Bool.self, forKey: .airplayBlocked)
        
        // Optional
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
    
    internal enum CodingKeys: String, CodingKey {
        case playToken
        case edrm
        case fairplay
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
    }
}
