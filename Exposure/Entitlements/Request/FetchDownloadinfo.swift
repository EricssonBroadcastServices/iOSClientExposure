//
//  Downloadinfo.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-05-08.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

public struct FetchDownloadinfo: ExposureType {
    
    public typealias Response = DownloadInfo
    
    /// Id of the asset to play
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
        var newEnvironment = environment
        newEnvironment.version = "v2"
        return newEnvironment.apiUrl + "/entitlement/" + assetId + "/downloadinfo"
    }
    
    /* public var parameters: PlayRequest {
     return playRequest
     } */
    
    public var parameters: [String: Any] {
        return [:]
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension FetchDownloadinfo {
    /// `PlayVod` request is specified as a `.post`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
