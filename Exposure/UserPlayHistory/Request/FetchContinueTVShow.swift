//
//  FetchContinueTVShow.swift
//  Exposure
//
//  Created by Johnny Sundblom on 2020-02-28.
//  Copyright © 2020 emp. All rights reserved.
//
import Foundation

/// Fetches the next episode to play for a tv-show
public struct FetchContinueTVShow: ExposureType {
    public typealias Response = ContinueTVShow
    
    /// Id for the asset to validate
    public let assetId: String
    
    /// `Environment` to use
    public let environment: Environment
    
    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken
    
    public init(assetId: String, environment: Environment, sessionToken: SessionToken) {
        self.assetId = assetId
        self.environment = environment
        self.sessionToken = sessionToken
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/userplayhistory/continue/tvshow/" + assetId
    }
    
    public var parameters: [String: Any] {
        return queryParams
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension FetchContinueTVShow {
    internal var queryParams: [String: Any] {
        return [:]
    }
}

extension FetchContinueTVShow {
    /// `FetchContinueTVShow` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
