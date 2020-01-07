//
//  UpdateUserDetails.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-01-07.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

/// *Exposure* request for updating *UserDetails*.
public struct UpdateUserDetails: ExposureType {

    public typealias Response = EmptyResponse
    
    public var endpointUrl: String {
        var environmentV2 = environment
        environmentV2.version = "v2"
        return environmentV2.apiUrl + "/user/details/"
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
    
    public var parameters: UserDetailsRequestParameters {
        return userDetailsRequestParameters
    }
    
    
    /// `Environment` to use
    public let environment: Environment
    
    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken
    
    public let language: String
    
    internal var userDetailsRequestParameters: UserDetailsRequestParameters {
        return UserDetailsRequestParameters(displayName: "", language: language)
    }
    
    public init(environment: Environment, sessionToken: SessionToken, language: String) {
        self.environment = environment
        self.sessionToken = sessionToken
        self.language = language
    }
    
    public func request() -> ExposureRequest<Response> {
        return request(.put)
    }
}
