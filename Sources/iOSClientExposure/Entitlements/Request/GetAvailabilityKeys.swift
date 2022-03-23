//
//  AvailabilityKeys.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-07-22.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation


/// Fetch Availability Keys associated with the session token
public struct GetAvailabilityKeys: ExposureType {
    public typealias Response = AvailabilityKeys
    
    /// `Environment` to use
    public let environment: Environment
    
    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken
    
    public init(environment: Environment, sessionToken: SessionToken) {
        self.environment = environment
        self.sessionToken = sessionToken
    }
    
    public var endpointUrl: String {
        var newEnvironment = environment
        newEnvironment.version = "v2"
        return newEnvironment.apiUrl + "/entitlement/availabilitykey"
    }
    
    public var parameters: [String: Any] {
        return [:]
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension GetAvailabilityKeys {
    
    
    /// `GetAvailabilityKeys` request is specified as a `.get`
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
