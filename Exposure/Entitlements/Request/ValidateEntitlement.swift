//
//  ValidateEntitlement.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Content rights for specific assets are subject to change throughout a `PlaybackEntitlement`s life cycle. `ValidateEntitlement` offers a method to validate a previously granted *entitlement*, returning an updated `PlaybackEntitlement.Status`.
public struct ValidateEntitlement: ExposureType, DRMRequest {
    public typealias Response = EntitlementValidation
    
    /// Id for the asset to validate
    public let assetId: String
    
    /// `Environment` to use
    public let environment: Environment
    
    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken
    
    /// `DRM` and *format* to validate.
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
            Keys.drm.rawValue: playRequest.drm,
            Keys.format.rawValue: playRequest.format
        ]
    }
}

extension ValidateEntitlement {
    /// `ValidateEntitlement` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get, encoding: ExposureURLEncoding(destination: .queryString))
    }
}
