//
//  CheckEntitlement.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2021-11-03.
//  Copyright © 2021 emp. All rights reserved.
//

import Foundation

/// Check user's ( given session token ) entitements for the given asset : assetId
public struct CheckEntitlement: ExposureType {
    
    public typealias Response = CheckEntitleResponse
    
    /// Id of the asset to get entitlements
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
        return newEnvironment.apiUrl + "/entitlement/" + assetId + "/entitle"
    }
    
    
    public var parameters: [String: Any] {
        return [:]
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension CheckEntitlement {
    /// `CheckEntitlement` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
