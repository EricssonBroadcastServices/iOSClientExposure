//
//  PostRating.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Create/Update a rating for an asset given by currently logged in user.
public struct PostRating: ExposureType {
    public typealias Response = [String:Any]?
    
    public var endpointUrl: String {
        return environment.apiUrl + "/rating/asset/" + assetId
    }
    
    public var parameters: [String: Any] {
        return [JSONKeys.rating.rawValue: rating]
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
    
    /// A rating between [0...1]
    public let rating: Float
    
    internal init(environment: Environment, sessionToken: SessionToken, assetId: String, rating: Float) {
        self.environment = environment
        self.sessionToken = sessionToken
        self.assetId = assetId
        self.rating = rating
    }
    
    /// Keys used to specify `json` body for the request.
    internal enum JSONKeys: String {
        case rating = "rating"
    }
}


extension PostRating {
    /// `PostRating` request is specified as a `.put`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest {
        return request(.put)
    }
}
