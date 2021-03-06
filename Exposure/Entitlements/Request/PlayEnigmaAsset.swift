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
    

    internal init(assetId: String, environment: Environment, sessionToken: SessionToken, adobePrimetimeMediaToken: String?) {
        self.assetId = assetId
        self.environment = environment
        self.sessionToken = sessionToken
        self.adobePrimetimeMediaToken = adobePrimetimeMediaToken
    }
    
    public var endpointUrl: String {
        var newEnvironment = environment
        newEnvironment.version = "v2"
        return newEnvironment.apiUrl + "/entitlement/" + assetId + "/play"
    }
    

    public var parameters: [String: Any] {
        return [:]
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
