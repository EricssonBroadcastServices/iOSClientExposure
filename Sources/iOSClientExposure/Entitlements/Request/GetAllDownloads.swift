//
//  GetAllDownloads.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-10-20.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

public struct GetAllDownloads: ExposureType {
    public typealias Response = AllDownloads
    
    /// `Environment` to use
    public let environment: Environment
    
    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken
    
    public init(environment: Environment, sessionToken: SessionToken) {
        self.environment = environment
        self.sessionToken = sessionToken
    }
    
    public var endpointUrl: String {
        var newEnvironment = environment
        newEnvironment.version = "v2"
        return newEnvironment.apiUrl + "/entitlement/downloads"
    }
    
    
    public var parameters: [String: Any] {
        return [:]
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension GetAllDownloads {
    /// `GetDownloadableInfo` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
