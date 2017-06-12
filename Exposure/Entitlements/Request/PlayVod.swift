//
//  PlayVod.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-23.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

public struct PlayVod: Exposure, DRMRequest {
    public typealias Response = PlaybackEntitlement
    
    public let assetId: String
    public let environment: Environment
    public let sessionToken: SessionToken
    
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
    public func request() -> ExposureRequest {
        return request(.post)
    }
}
