//
//  PlayCatchup.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct PlayCatchup: Exposure, DRMRequest {
    public typealias Response = PlaybackEntitlement
    
    public let channelId: String
    public let programId: String
    public let environment: Environment
    public let sessionToken: SessionToken
    
    public var playRequest: PlayRequest
    
    internal init(channelId: String, programId: String, playRequest: PlayRequest = PlayRequest(), environment: Environment, sessionToken: SessionToken) {
        self.channelId = channelId
        self.programId = programId
        self.playRequest = playRequest
        self.environment = environment
        self.sessionToken = sessionToken
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/entitlement/channel/" + channelId + "/programId" + programId + "/play"
    }
    
    public var parameters: [String: Any] {
        return playRequest.toJSON()
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension PlayLive {
    public func request() -> ExposureRequest {
        return request(.post)
    }
}
