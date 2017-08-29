//
//  TwoFactorLogin.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Exposure* endpoint integration for handling *Two Factor Login* with *username* and *password*.
public struct TwoFactorLogin: Exposure {
    public typealias Response = Credentials
    
    /// Username to authenticate with
    public let username: String
    
    /// Password associated with `username`
    public let password: String
    
    /// Two factor token to use
    public let twoFactor: String
    
    /// `true` extends period of session validity, `false` uses normal validation period.
    public let rememberMe: Bool
    
    /// `DeviceInfo` required by *Exposure*
    public let deviceInfo: DeviceInfo = DeviceInfo()
    
    /// Environment to use
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
    
    /// Keys used to specify `json` body for the request.
    internal enum JSONKeys: String {
        case username = "username"
        case password = "password"
        case rememberMe = "rememberMe"
        case twoFactor = "totp"
    }
}

extension TwoFactorLogin {
    /// `TwoFactorLogin` request is specified as a `.post`
    public func request() -> ExposureRequest {
        return request(.post)
    }
}
