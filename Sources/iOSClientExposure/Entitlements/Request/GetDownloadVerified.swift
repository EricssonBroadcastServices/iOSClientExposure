//
//  GetDownloadVerified.swift
//  
//
//  Created by Udaya Sri Senarathne on 2023-10-03.
//

import Foundation

public struct GetDownloadVerified: ExposureType {
    
    public typealias Response = DownloadVerified
    
    /// Id of the asset to get downloadInfo
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
        return newEnvironment.apiUrl + "/entitlement/" + assetId + "/downloadverified"
    }
    
    
    public var parameters: [String: Any] {
        return [:]
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension GetDownloadVerified {
    /// `GetDownloadableInfo` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
