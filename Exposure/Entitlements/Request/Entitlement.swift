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
    
    
    public func enigmaAsset(assetId: String) -> PlayEnigmaAsset {
        return PlayEnigmaAsset(assetId: assetId,
                               environment: environment,
                               sessionToken: sessionToken)
    }
    
    public func enigmaAsset(assetId: String, includeAds adsOptions:AdsOptions) -> PlayEnigmaAdsAsset {
        return PlayEnigmaAdsAsset(assetId: assetId,
                               environment: environment,
                               sessionToken: sessionToken,
                               includeAdsOptions: adsOptions)
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
    /// - returns: `DownloadVod` struct used to process the request
    public func download(assetId: String) -> DownloadVod {
        return DownloadVod(assetId: assetId,
                           environment: environment,
                           sessionToken: sessionToken)
    }
    
    /// Checks if the user is entitled to the asset with assetId.
    ///
    /// - parameter assetId: asset to validate
    /// - returns: `ValidateEntitlement` struct used to process the request
    public func validate(assetId: String) -> ValidateEntitlement {
        return ValidateEntitlement(assetId: assetId,
                                   environment: environment,
                                   sessionToken: sessionToken)
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
