//
//  FetchRating.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Get rating of an asset given by the currently logged in user.
public struct FetchRating: ExposureType {
    public typealias Response = UserRating
    
    public var endpointUrl: String {
        return environment.apiUrl + "/rating/asset/" + assetId
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
    
    /// The asset to rate
    public let assetId: String
    
    internal init(environment: Environment, sessionToken: SessionToken, assetId: String) {
        self.environment = environment
        self.sessionToken = sessionToken
        self.assetId = assetId
    }
}

extension FetchRating {
    /// `FetchRating` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response>{
        return request(.get)
    }
}

