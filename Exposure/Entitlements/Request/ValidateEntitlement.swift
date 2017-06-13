//
//  ValidateEntitlement.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct ValidateEntitlement: Exposure, DRMRequest {
    public typealias Response = EntitlementValidation
    
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
        return environment.apiUrl + "/entitlement/" + assetId
    }
    
    public var parameters: [String: Any] {
        return queryParams
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension ValidateEntitlement {
    internal enum Keys: String {
        case drm = "drm"
        case format = "format"
    }
    
    internal var queryParams: [String: Any] {
        return [
            Keys.drm.rawValue: playRequest.drm.rawValue,
            Keys.format.rawValue: playRequest.format.rawValue
        ]
    }
}

extension ValidateEntitlement {
    public func request() -> ExposureRequest {
        return request(.get, encoding: ExposureURLEncoding.default)
    }
}
