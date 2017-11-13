//
//  Rating.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-11-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Rating {
    public let environment: Environment
    public let sessionToken: SessionToken
    
    public init(environment: Environment, sessionToken: SessionToken) {
        self.environment = environment
        self.sessionToken = sessionToken
    }
}

extension Rating {
    public func rate(assetId: String, to value: Float) -> PostRating {
        return PostRating(environment: environment,
                          sessionToken: sessionToken,
                          assetId: assetId,
                          rating: value)
    }
}

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
