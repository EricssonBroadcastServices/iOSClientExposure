//
//  ValidateEntitlement.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Content rights for specific assets are subject to change throughout a `PlaybackEntitlement`s life cycle. `ValidateEntitlement` offers a method to validate a previously granted *entitlement*, returning an updated `PlaybackEntitlement.Status`.
public struct ValidateEntitlement: ExposureType {
    public typealias Response = EntitlementValidation
    
    /// Id for the asset to validate
    public let assetId: String
    
    /// `Environment` to use
    public let environment: Environment
    
    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken
    
    public let  programStartTime: String?
    

    public init(assetId: String, environment: Environment, sessionToken: SessionToken, programStartTime: String? = nil  ) {
        self.assetId = assetId
        self.environment = environment
        self.sessionToken = sessionToken
        self.programStartTime = programStartTime
    }
    
    public var endpointUrl: String {
        var environmentV2 = environment
        environmentV2.version = "v2"
        return environmentV2.apiUrl + "/entitlement/" + assetId + "/entitle"
    }
    
    public var parameters: [String: Any] {
        var parameters: [String: String] = [:]
        if let programStartTime = programStartTime {
            parameters["time"] = programStartTime
            return parameters
        } else {
            return [:]
        }
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension ValidateEntitlement {
    /// `ValidateEntitlement` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
