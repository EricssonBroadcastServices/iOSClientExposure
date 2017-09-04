//
//  ValidateSessionToken.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-04.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Validates a session with the underlying CRM to make sure it is still valid.
public struct ValidateSessionToken: Exposure {
    public typealias Response = SessionResponse
    
    /// Auth token to invalidate
    public let sessionToken: SessionToken
    
    /// Environment to use
    public let environment: Environment
    
    internal init(sessionToken: SessionToken, environment: Environment) {
        self.sessionToken = sessionToken
        self.environment = environment
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/auth/session"
    }
    
    public var parameters: [String: Any]? {
        return nil
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension ValidateSessionToken {
    /// `ValidateSessionToken` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest {
        return request(.get)
    }
}
