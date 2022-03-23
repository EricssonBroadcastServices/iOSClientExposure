//
//  FetchUserDetails.swift
//  Exposure-iOS
//
//  Created by Udaya Sri Senarathne on 2020-01-07.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

/// *Exposure* request for fetching *UserDetails*.
public struct FetchUserDetails: ExposureType {

    public typealias Response = UserDetails
    
    public var endpointUrl: String {
        var environmentV2 = environment
        environmentV2.version = "v2"
        return environmentV2.apiUrl + "/user/details/"
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
    
    public var parameters: [String: Any] {
        return [:]
    }
    
    
    /// `Environment` to use
    public let environment: Environment
    
    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken
    
    public init(environment: Environment, sessionToken: SessionToken) {
        self.environment = environment
        self.sessionToken = sessionToken
    }
    
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
