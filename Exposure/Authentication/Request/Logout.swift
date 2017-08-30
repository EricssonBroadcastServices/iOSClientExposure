//
//  Logout.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-12.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

/// *Exposure* endpoint integration for *Logout*.
public struct Logout: Exposure {
    public typealias Response = [String:Any]
    
    /// Auth token to invalidate
    public let sessionToken: SessionToken
    
    /// Environment to use
    public let environment: Environment
    
    internal init(sessionToken: SessionToken, environment: Environment) {
        self.sessionToken = sessionToken
        self.environment = environment
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/auth/session"
    }
    
    public var parameters: [String: Any]? {
        return nil
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension Logout {
    /// `Login` request is specified as a `.delete`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest {
        return request(.delete)
    }
}

/// Simple hack to allow a `Dictionary` to be expected as `Exposure.Response`
extension Dictionary: ExposureConvertible {
    public init?(json: Any) {
        self.init()
    }
}
