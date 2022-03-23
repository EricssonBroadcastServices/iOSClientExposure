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
    
    public func rating(for assetId: String) -> FetchRating {
        return FetchRating(environment: environment,
                           sessionToken: sessionToken,
                           assetId: assetId)
    }
    
    public func list() -> FetchRatingsList {
        return FetchRatingsList(environment: environment,
                                sessionToken: sessionToken)
    }
    
    public func allRatings(for assetId: String) -> FetchAllRatings {
        return FetchAllRatings(environment: environment,
                               sessionToken: sessionToken,
                               assetId: assetId)
    }
    
    public func remove(ratingFor assetId: String) -> DeleteRating {
        return DeleteRating(environment: environment,
                            sessionToken: sessionToken,
                            assetId: assetId)
    }
}
