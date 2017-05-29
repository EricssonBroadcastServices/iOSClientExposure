//
//  TwoFactorLogin.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct TwoFactorLogin: Exposure {
    public typealias Response = Credentials
    
    public let username: String
    public let password: String
    public let twoFactor: String
    public let rememberMe: Bool
    public let deviceInfo: DeviceInfo = DeviceInfo()
    public let environment: Environment
    
    internal init(username: String, password: String, twoFactor: String, rememberMe: Bool = false, environment: Environment) {
        self.username = username
        self.password = password
        self.twoFactor = twoFactor
        self.rememberMe = rememberMe
        self.environment = environment
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/auth/twofactorlogin"
    }
    
    public var parameters: [String: Any] {
        var json = deviceInfo.toJSON()
        
        json[JSONKeys.username.rawValue] = username
        json[JSONKeys.password.rawValue] = password
        json[JSONKeys.twoFactor.rawValue] = twoFactor
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
        case twoFactor = "totp"
    }
}
