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
    /// Play token to use for either PlayReady or MRR. Will be empty if the status is not SUCCESS.
    public let playToken: String?
    
    /// The EDRM specific configuration. Will be empty if the status is not SUCCESS.
    public let edrm: EDRMConfiguration?
    
    /// The Fairplay specific configuration. Will be empty if the status is not SUCCESS or nor Fairplay configurations.
    public let fairplay: FairplayConfiguration?
    
    /// The information needed to locate the media. FOR EDRM this will be the media uid, for other formats it's the URL of the media.
    public let mediaLocator: String?
    
    /// The datetime of expiration of the drm license.
    public let licenseExpiration: String?
    
    ///The reason of expiration of the drm license.
    public let licenseExpirationReason: Status?
    
    /// The datetime of activation of the drm license.
    public let licenseActivation: String?
    
    /// The expiration of the the play token. The player needs to be initialized and done the play call before this.
    public let playTokenExpiration: String?
    
    /// The type of entitlement that granted access to this play.
    public let entitlementType: EntitlementType?
    
    /// If this is a live entitlement.
    public let live: Bool?
    
    /// Unique id of this playback session, all analytics events for this session should be reported on with this id
    public let playSessionId: String?
    
    /// If fast forward is enabled
    public let ffEnabled: Bool?
    
    /// If timeshift is disabled
    public let timeshiftEnabled: Bool?
    
    /// If rewind is enabled
    public let rwEnabled: Bool?
    
    /// Min bitrate to use
    public let minBitrate: Int?
    
    /// Max bitrate to use
    public let maxBitrate: Int?
    
    /// Max height resolution
    public let maxResHeight: Int?
    
    /// If airplay is blocked
    public let airplayBlocked: Bool?
    
    /// MDN Request Router Url
    public let mdnRequestRouterUrl: String?
    
    /// Last viewed offset. Used by *Session Shift*
    public let lastViewedOffset: Int?
    
    /// Details the `PlaybackEntitlement`s *license* status
    public enum Status {
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
    }
    
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

extension PlaybackEntitlement: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        playToken = try? container.decode(String.self, forKey: .playToken)
        
        edrm = try? container.decode(EDRMConfiguration.self, forKey: .edrm)
        fairplay = try? container.decode(FairplayConfiguration.self, forKey: .fairplay)

        mediaLocator = try? container.decode(String.self, forKey: .mediaLocator)
        licenseExpiration = try? container.decode(String.self, forKey: .licenseExpiration)
        licenseExpirationReason = Status(string: try? container.decode(String.self, forKey: .licenseExpirationReason))
        licenseActivation = try? container.decode(String.self, forKey: .licenseActivation)
        
        playTokenExpiration = try? container.decode(String.self, forKey: .playTokenExpiration)
        entitlementType = EntitlementType(string: try? container.decode(String.self, forKey: .entitlementType))

        live = try? container.decode(Bool.self, forKey: .live)
        playSessionId = try? container.decode(String.self, forKey: .playSessionId)
        ffEnabled = try? container.decode(Bool.self, forKey: .ffEnabled)
        timeshiftEnabled = try? container.decode(Bool.self, forKey: .timeshiftEnabled)
        rwEnabled = try? container.decode(Bool.self, forKey: .rwEnabled)
        minBitrate = try? container.decode(Int.self, forKey: .minBitrate)
        maxBitrate = try? container.decode(Int.self, forKey: .maxBitrate)
        maxResHeight = try? container.decode(Int.self, forKey: .maxResHeight)
        airplayBlocked = try? container.decode(Bool.self, forKey: .airplayBlocked)
        mdnRequestRouterUrl = try? container.decode(String.self, forKey: .mdnRequestRouterUrl)
        lastViewedOffset = try? container.decode(Int.self, forKey: .lastViewedOffset)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case playToken = "playToken"
        case edrm = "edrmConfig"
        case fairplay = "fairplayConfig"
        case mediaLocator = "mediaLocator"
        case licenseExpiration = "licenseExpiration"
        case licenseExpirationReason = "licenseExpirationReason"
        case licenseActivation = "licenseActivation"
        case playTokenExpiration = "playTokenExpiration"
        case entitlementType = "entitlementType"
        case live = "live"
        case playSessionId = "playSessionId"
        case ffEnabled = "ffEnabled"
        case timeshiftEnabled = "timeshiftEnabled"
        case rwEnabled = "rwEnabled"
        case minBitrate = "minBitrate"
        case maxBitrate = "maxBitrate"
        case maxResHeight = "maxResHeight"
        case airplayBlocked = "airplayBlocked"
        case mdnRequestRouterUrl = "mdnRequestRouterUrl"
        case lastViewedOffset = "lastViewedOffset"
    }
}
