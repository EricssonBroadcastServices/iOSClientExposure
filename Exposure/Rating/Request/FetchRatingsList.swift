//
//  FetchRatingsList.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Give all asset ratings given by currently logged in user.
public struct FetchRatingsList: ExposureType {
    public typealias Response = [String:Any]?
    
    public var endpointUrl: String {
        return environment.apiUrl + "/rating/asset/all"
    }
    
    public var parameters: [String: Any]? {
        return nil
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
    
    /// `Environment` to use
    public let environment: Environment
    
    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken
    
    internal init(environment: Environment, sessionToken: SessionToken) {
        self.environment = environment
        self.sessionToken = sessionToken
    }
}

extension FetchRatingsList {
    /// `FetchRatingsList` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest {
        return request(.get)
    }
}
