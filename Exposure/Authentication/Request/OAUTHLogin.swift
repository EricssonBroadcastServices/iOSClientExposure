//
//  OAUTHLogin.swift
//  Exposure
//
//  Created by Alessandro dos Santos Pinto on 2021-08-25.
//  Copyright © 2021 emp. All rights reserved.
//

import Foundation

/// *Exposure* endpoint integration for handling *Login* through *OAUTH*.
public struct OAUTHLogin: ExposureType, Encodable {
    
    public typealias Response = Credentials
    
    /// Token to authenticate with
    public let token: String
    
    /// Device specific information
    public let device: Device = Device()
    
    /// `Environment` to use
    public let environment: Environment
    
    public init(environment: Environment, token: String) {
        self.environment = environment
        self.token = token
    }
    
    public var endpointUrl: String {
        var environmentV2 = environment
        environmentV2.version = "v2"
        return environmentV2.apiUrl + "/auth/oauthLogin"
    }
    
    public var parameters: OAUTHLogin {
        return self
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
        try container.encode(device, forKey: .device)
    }
    
    /// Keys used to specify `json` body for the request.
    internal enum CodingKeys: String, CodingKey {
        case token
        case device
    }
    
}

extension OAUTHLogin {
    
    /// `OAUTHLogin` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.post)
    }
    
    public func oauthLogin(token: String) -> OAUTHLogin {
        return OAUTHLogin(environment: self.environment,
                          token: self.token)
    }
    
}
