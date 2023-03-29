//
//  Entitlement.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-12.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Requesting and validating user `Entitlement`s from *Exposure* requires a configured `Environment` and a valid `SessionToken`.
public struct Entitlement {
    /// `Environment` to use
    public let environment: Environment
    
    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken

    public init(environment: Environment, sessionToken: SessionToken) {
        self.environment = environment
        self.sessionToken = sessionToken
    }
}

extension Entitlement {
    /// If the *entitlement checks* pass, will return the information needed to initialize the player for the requested streaming format.
    ///
    /// Default streaming format is:
    /// * `drm` FAIRPLAY
    /// * `format` HLS
    ///
    /// - parameter assetId: asset to request
    /// - returns: `PlayVod` struct used to process the request
    public func vod(assetId: String) -> PlayVod {
        return PlayVod(assetId: assetId,
                       environment: environment,
                       sessionToken: sessionToken)
    }
    
    /// `Entitlement`s are set on program level, so this is shorthand for getting the epg and playing the currently live program.
    /// If the *entitlement checks* pass, will return the information needed to initialize the player for the requested streaming format.
    ///
    /// Default streaming format is:
    /// * `drm` FAIRPLAY
    /// * `format` HLS
    ///
    /// If there is no current program live will return `NOT_ENABLED`.
    ///
    /// - parameter channelId: channel to request
    /// - returns: `PlayLive` struct used to process the request
    public func live(channelId: String) -> PlayLive {
        return PlayLive(channelId: channelId,
                        environment: environment,
                        sessionToken: sessionToken)
    }
    
    /// Play any asset 
    /// - Parameters:
    ///   - assetId: asset id
    ///   - adobePrimetimeMediaToken: adobePrimetimeMediaToken
    ///   - materialProfile: specific material variant : "default" material contains a full length movie, and a "TRAILER" material might contain only an extract: a virtual subclip generated using the VOD to VOD flow)
    ///   - deviceMake: deviceMake : `Apple`
    ///   - deviceModel: device model  ex `appletv-11-1 / iphone-12-5`
    /// - Returns: `PlayEnigmaAsset` struct used to process the request
    public func enigmaAsset(assetId: String, with adobePrimetimeMediaToken: String? = nil, use materialProfile: String? = nil, deviceMake:String? = nil, deviceModel: String? = nil ) -> PlayEnigmaAsset {
        return PlayEnigmaAsset(assetId: assetId,
                               environment: environment,
                               sessionToken: sessionToken, adobePrimetimeMediaToken: adobePrimetimeMediaToken, materialProfile: materialProfile, deviceMake: deviceMake, deviceModel: deviceModel)
    }
    
    
    
    /// Play Assets with Ads
    /// - Parameters:
    ///   - assetId: asset id
    ///   - adsOptions: ssai specific ads options
    ///   - adobePrimetimeMediaToken: adobePrimetimeMediaToken
    ///   - materialProfile: specific material variant : "default" material contains a full length movie, and a "TRAILER" material might contain only an extract: a virtual subclip generated using the VOD to VOD flow
    ///   - customAdParams: ssai specific custom ads params
    ///   - deviceMake: deviceMake : `Apple`
    ///   - deviceModel: device model  ex `appletv-11-1 / iphone-12-5`
    /// - Returns: `PlayEnigmaAdsAsset` struct used to process the request
    public func enigmaAsset(assetId: String, includeAds adsOptions:AdsOptions, with adobePrimetimeMediaToken: String? = nil, use materialProfile: String? = nil, add customAdParams: [String: Any]? = nil, deviceMake:String? = nil, deviceModel: String? = nil ) -> PlayEnigmaAdsAsset {
        return PlayEnigmaAdsAsset(assetId: assetId,
                               environment: environment,
                               sessionToken: sessionToken,
                                  includeAdsOptions: adsOptions, adobePrimetimeMediaToken: adobePrimetimeMediaToken, materialProfile: materialProfile, customAdParams: customAdParams, deviceMake: deviceMake, deviceModel: deviceModel)
    }
    
    /// If the *entitlement checks* pass, will return the information needed to initialize the player for the requested streaming format.
    ///
    /// Default streaming format is:
    /// * `drm` FAIRPLAY
    /// * `format` HLS
    ///
    /// - parameter channelId: channel broadcasting the program
    /// - parameter programId: program to request
    /// - returns: `PlayCatchup` struct used to process the request
    public func program(programId: String, channelId: String) -> PlayProgram {
        return PlayProgram(channelId: channelId,
                           programId: programId,
                           environment: environment,
                           sessionToken: sessionToken)
    }

    /// If the *entitlement checks* pass, will return the information needed to initialize the player for the requested streaming format.
    ///
    /// Default streaming format is:
    /// * `drm` FAIRPLAY
    /// * `format` HLS
    ///
    /// - parameter assetId: asset to request
    /// - parameter deviceMake: deviceMake : `Apple`
    /// - parameter deviceModel: device model ex `appletv-11-1 / iphone-12-5`
    /// - returns: `DownloadVod` struct used to process the request
    public func download(assetId: String, deviceMake:String? = nil, deviceModel: String? = nil ) -> DownloadVod {
        return DownloadVod(assetId: assetId,
                           environment: environment,
                           sessionToken: sessionToken, deviceMake: deviceMake , deviceModel: deviceModel)
    }
    
    /// Checks if the user is entitled to the asset with assetId.
    ///
    /// - parameter assetId: asset to validate
    /// - parameter entitlementDate: date/time to run the entitlement for ( ex : programStartTime + 1ms )
    /// - returns: `ValidateEntitlement` struct used to process the request
    public func validate(assetId: String, entitlementDate: String?) -> ValidateEntitlement {
        return ValidateEntitlement(assetId: assetId,
                                   environment: environment,
                                   sessionToken: sessionToken,
                                   entitlementDate: entitlementDate )
    }
    
    /// Checks if the user is entitled to the asset with assetId.
    ///
    /// - parameter downloadId: asset to validate
    /// - returns: `DownloadValidation` struct used to process the request
    public func validate(downloadId: String) -> ValidateDownload {
        return ValidateDownload(assetId: downloadId,
                                environment: environment,
                                sessionToken: sessionToken)
    }
}
