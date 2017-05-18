//
//  Login.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Login: Exposure {
    public typealias Response = Credentials
    
    public let username: String
    public let password: String
    public let rememberMe: Bool
    public let deviceInfo: DeviceInfo = DeviceInfo()
    public let environment: Environment
    
    public init(username: String, password: String, rememberMe: Bool = false, environment: Environment) {
        self.username = username
        self.password = password
        self.rememberMe = rememberMe
        self.environment = environment
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/auth/login"
    }
    
    public var parameters: [String: Any] {
        var json = deviceInfo.toJSON()
        
        json[JSONKeys.username.rawValue] = username
        json[JSONKeys.password.rawValue] = password
        json[JSONKeys.rememberMe.rawValue] = rememberMe
        
        return json
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    internal enum JSONKeys: String {
        case username = "username"
        case password = "password"
        case rememberMe = "rememberMe"
    }
}

extension Login {
    public func request() -> ExposureRequest {
        return request(.post)
    }
}
