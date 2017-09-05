//
//  PlayVod.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-23.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

/// Request a `PlaybackEntitlement` for *Vod* playback.
///
/// If the *entitlement checks* pass, will return the information needed to initialize the player for the requested streaming format.
///
/// Default streaming format is:
/// * `drm` FAIRPLAY
/// * `format` HLS
public struct PlayVod: Exposure, DRMRequest {
    public typealias Response = PlaybackEntitlement
    
    /// Id of the asset to play
    public let assetId: String
    
    /// `Environment` to use
    public let environment: Environment
    
    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken
    
    /// `DRM` and *format* to request.
    public var playRequest: PlayRequest
    
    internal init(assetId: String, playRequest: PlayRequest = PlayRequest(), environment: Environment, sessionToken: SessionToken) {
        self.assetId = assetId
        self.playRequest = playRequest
        self.environment = environment
        self.sessionToken = sessionToken
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/entitlement/" + assetId + "/play"
    }
    
    public var parameters: [String: Any] {
        return playRequest.toJSON()
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension PlayVod {
    /// `PlayVod` request is specified as a `.post`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest {
        return request(.post)
    }
}
