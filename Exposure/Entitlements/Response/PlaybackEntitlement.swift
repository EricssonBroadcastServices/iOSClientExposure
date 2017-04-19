//
//  PlaybackEntitlement.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-23.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct PlaybackEntitlement {
    public let playToken: String? // Play token to use for either PlayReady or MRR. Will be empty if the status is not SUCCESS.
    
    public let edrm: EDRMConfiguration? // The EDRM specific configuration. Will be empty if the status is not SUCCESS.
    public let fairplay: FairplayConfiguration? // The Fairplay specific configuration. Will be empty if the status is not SUCCESS or nor Fairplay configurations.
    public let mediaLocator: String? //The information needed to locate the media. FOR EDRM this will be the media uid, for other formats it's the URL of the media.
    public let licenseExpiration: String? // The datetime of expiration of the drm license.
    public let licenseExpirationReason: ExpirationReason? //The reason of expiration of the drm license.
    public let licenseActivation: String? // The datetime of activation of the drm license.,
    public let playTokenExpiration: String? // The expiration of the the play token. The player needs to be initialized and done the play call before this.
    public let entitlementType: EntitlementType? // The type of entitlement that granted access to this play.
    public let live: Bool? // If this is a live entitlement.
    public let playSessionId: String? // Unique id of this playback session, all analytics events for this session should be reported on with this id
    public let ffEnabled: Bool? // If fast forward is enabled
    public let timeshiftEnabled: Bool? // If timeshift is disabled
    public let rwEnabled: Bool? // If rewind is enabled
    public let minBitrate: Int? // Min bitrate to use
    public let maxBitrate: Int? // Max bitrate to use
    public let maxResHeight: Int? // Max height resolution
    public let airplayBlocked: Bool? // If airplay is blocked
    public let mdnRequestRouterUrl: String? // MDN Request Router Url
    
    public enum ExpirationReason: String {
        case success = "SUCCESS"
        case notEntitled = "NOT_ENTITLED"
        case geoBlocked = "GEO_BLOCKED"
        case downloadBlocked = "DOWNLOAD_BLOCKED"
        case deviceBlocked = "DEVICE_BLOCKED"
        case licenseExpired = "LICENSE_EXPIRED"
        case notAvailableInFormat = "NOT_AVAILABLE_IN_FORMAT"
        case concurrentStreamsLimitReached = "CONCURRENT_STREAMS_LIMIT_REACHED"
        case notEnabled = "NOT_ENABLED"
        case gapInEPG = "GAP_IN_EPG"
        case epgPlayMaxHours = "EPG_PLAY_MAX_HOURS"
    }
    
    public enum EntitlementType: String {
        case tvod = "TVOD"
        case svod = "SVOD"
        case fvod = "FVOD"
    }
}

extension PlaybackEntitlement: ExposureConvertible {
    public init?(json: JSON) {
        let actualJSON = SwiftyJSON.JSON(json)
        playToken = actualJSON[JSONKeys.playToken.rawValue].string
        edrm = EDRMConfiguration(json: actualJSON[JSONKeys.edrm.rawValue].dictionaryObject ?? [:])
        fairplay = FairplayConfiguration(json: actualJSON[JSONKeys.fairplay.rawValue].dictionaryObject ?? [:])
        mediaLocator = actualJSON[JSONKeys.mediaLocator.rawValue].string
        licenseExpiration = actualJSON[JSONKeys.licenseExpiration.rawValue].string
        licenseExpirationReason = ExpirationReason(rawValue: actualJSON[JSONKeys.licenseExpirationReason.rawValue].string ?? "")
        licenseActivation = actualJSON[JSONKeys.licenseActivation.rawValue].string
        playTokenExpiration = actualJSON[JSONKeys.playTokenExpiration.rawValue].string
        entitlementType = EntitlementType(rawValue: actualJSON[JSONKeys.entitlementType.rawValue].string ?? "")
        live = actualJSON[JSONKeys.live.rawValue].bool
        playSessionId = actualJSON[JSONKeys.playSessionId.rawValue].string
        ffEnabled = actualJSON[JSONKeys.ffEnabled.rawValue].bool
        timeshiftEnabled = actualJSON[JSONKeys.timeshiftEnabled.rawValue].bool
        rwEnabled = actualJSON[JSONKeys.rwEnabled.rawValue].bool
        minBitrate = actualJSON[JSONKeys.minBitrate.rawValue].int
        maxBitrate = actualJSON[JSONKeys.maxBitrate.rawValue].int
        maxResHeight = actualJSON[JSONKeys.maxResHeight.rawValue].int
        airplayBlocked = actualJSON[JSONKeys.airplayBlocked.rawValue].bool
        mdnRequestRouterUrl = actualJSON[JSONKeys.mdnRequestRouterUrl.rawValue].string
    }
    
    internal enum JSONKeys: String {
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
    }
}
