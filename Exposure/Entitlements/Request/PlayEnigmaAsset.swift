//
//  PlayAsset.swift
//  Exposure-iOS
//
//  Created by Udaya Sri Senarathne on 2019-04-10.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation

/// Request a `PlaybackEntitlement` for *Vod* playback.
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
    
    internal init(assetId: String, environment: Environment, sessionToken: SessionToken) {
        self.assetId = assetId
        self.environment = environment
        self.sessionToken = sessionToken
    }
    
    public var endpointUrl: String {
        var newEnvironment = environment
        newEnvironment.version = "v2"
        return newEnvironment.apiUrl + "/entitlement/" + assetId + "/play"
    }
    
    /* public var parameters: PlayRequest {
     return playRequest
     } */
    
    public var parameters: [String: Any] {
        return [:]
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
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
