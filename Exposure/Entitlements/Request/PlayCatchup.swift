//
//  PlayCatchup.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Request a `PlaybackEntitlement` for *catchup* playback of a specific *program*.
///
/// If the *entitlement checks* pass, will return the information needed to initialize the player for the requested streaming format.
///
/// Default streaming format is:
/// * `drm` FAIRPLAY
/// * `format` HLS
///
/// If there is no current program live will return `NOT_ENABLED`.
public struct PlayCatchup: ExposureType, DRMRequest {
    public typealias Response = PlaybackEntitlement
    
    /// Channel of the program to play.
    public let channelId: String
    
    /// Id of the program to play.
    public let programId: String
    
    /// `Environment` to use
    public let environment: Environment
    
    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken
    
    /// `DRM` and *format* to request.
    public var playRequest: PlayRequest
    
    internal init(channelId: String, programId: String, playRequest: PlayRequest = PlayRequest(), environment: Environment, sessionToken: SessionToken) {
        self.channelId = channelId
        self.programId = programId
        self.playRequest = playRequest
        self.environment = environment
        self.sessionToken = sessionToken
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/entitlement/channel/" + channelId + "/program/" + programId + "/play"
    }
    
    public var parameters: [String: Any] {
        return playRequest.toJSON()
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension PlayCatchup {
    /// `PlayCatchup` request is specified as a `.post`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.post)
    }
}
