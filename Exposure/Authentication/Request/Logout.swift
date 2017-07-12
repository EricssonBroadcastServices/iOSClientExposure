//
//  Logout.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-12.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

public struct Logout: Exposure {
    public typealias Response = [String:Any]
    
    public let sessionToken: SessionToken
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
    public func request() -> ExposureRequest {
        return request(.delete)
    }
}

extension Dictionary: ExposureConvertible {
    public init?(json: Any) {
        self.init()
    }
}
