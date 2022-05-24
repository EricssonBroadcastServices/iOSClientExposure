//
//  PlayAsset.swift
//  Exposure-iOS
//
//  Created by Udaya Sri Senarathne on 2019-04-10.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation

/// Request a `PlaybackEntitlementV2` for *Asset* playback.
///
/// If the *entitlement checks* pass, will return the information needed to initialize the player for the requested streaming format.
///
/// Default streaming format is:
/// * `drm` FAIRPLAY
/// * `format` HLS
public struct PlayEnigmaAsset: ExposureType {
    
    public typealias Response = PlayBackEntitlementV2
    
    /// Id of the asset to play
    public let assetId: String
    
    /// `Environment` to use
    public let environment: Environment
    
    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken
    
    /// X-Adobe-Primetime-MediaToken
    public let adobePrimetimeMediaToken: String?
    
    // used to play a specific material variant : "default" material contains a full length movie, and a "TRAILER" material might contain only an extract: a virtual subclip generated using the VOD to VOD flow)
    public let materialProfile: String?
    

    internal init(assetId: String, environment: Environment, sessionToken: SessionToken, adobePrimetimeMediaToken: String?, materialProfile: String? ) {
        self.assetId = assetId
        self.environment = environment
        self.sessionToken = sessionToken
        self.adobePrimetimeMediaToken = adobePrimetimeMediaToken
        self.materialProfile = materialProfile
    }
    
    public var endpointUrl: String {
        var newEnvironment = environment
        newEnvironment.version = "v2"
        return newEnvironment.apiUrl + "/entitlement/" + assetId + "/play"
    }
    

    public var parameters: [String: Any] {
        var parameters: [String: String] = [:]
        
        // Adding `supportedFormats` & `supportedDrms` to parameters
        parameters["supportedFormats"] = "hls,mp3"
        parameters["supportedDrms"] = "fairplay"
        
        // Add materialProfile if available
        if let materialProfile = materialProfile {
            parameters["materialProfile"] = materialProfile
        }
        return parameters
    }
    
    
    /// Headers to apply
    public var headers: [String: String]? {
        var result: [String: String] = [:]
        
        if let adobePrimeTimeToken = adobePrimetimeMediaToken {
             result["X-Adobe-Primetime-MediaToken"] = adobePrimeTimeToken
        }
        sessionToken.authorizationHeader.forEach{ result[$0] = $1 }
        
        
        return result.isEmpty ? nil : result
    }
    
}

extension PlayEnigmaAsset {
    /// `PlayVod` request is specified as a `.post`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {

        return request(.get)
    }
}
