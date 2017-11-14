//
//  PlayLive.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-12.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Request a `PlaybackEntitlement` for *Live* playback on the specified *channel*.
///
/// `Entitlement`s are set on program level, so this is shorthand for getting the epg and playing the currently live program.
/// If the *entitlement checks* pass, will return the information needed to initialize the player for the requested streaming format.
///
/// Default streaming format is:
/// * `drm` FAIRPLAY
/// * `format` HLS
///
/// If there is no current program live will return `NOT_ENABLED`.
public struct PlayLive: ExposureType, DRMRequest {
    public typealias Response = PlaybackEntitlement
    
    /// Channel of the program to play.
    public let channelId: String
    
    /// `Environment` to use
    public let environment: Environment
    
    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken
    
    /// `DRM` and *format* to request.
    public var playRequest: PlayRequest
    
    internal init(channelId: String, playRequest: PlayRequest = PlayRequest(), environment: Environment, sessionToken: SessionToken) {
        self.channelId = channelId
        self.playRequest = playRequest
        self.environment = environment
        self.sessionToken = sessionToken
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/entitlement/channel/" + channelId + "/play"
    }
    
    public var parameters: [String: Any] {
        return playRequest.toJSON()
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension PlayLive {
    /// `PlayLive` request is specified as a `.post`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.post)
    }
    
    /// Transform a `PlayLive` request into a `PlayCatchup` request
    ///
    /// - parameter programId: program to request
    /// - returns: `PlayCatchup` struct used to process the request.
    public func catchup(programId: String) -> PlayCatchup {
        return PlayCatchup(channelId: channelId,
                           programId: programId,
                           environment: environment,
                           sessionToken: sessionToken)
    }
}
