//
//  Login.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Exposure* endpoint integration for handling *Login* through *username* and *password*.
public struct Login: ExposureType {
    public typealias Response = Credentials
    
    /// Username to authenticate with
    public let username: String
    
    /// Password associated with `username`
    public let password: String
    
    /// Two factor token to use
    public let twoFactor: String?
    
    /// `true` extends period of session validity, `false` uses normal validation period.
    public let rememberMe: Bool
    
    /// `DeviceInfo` required by *Exposure*
    public let deviceInfo: DeviceInfo = DeviceInfo()
    
    /// Environment to use
    public let environment: Environment
    
    internal init(username: String, password: String, twoFactor: String? = nil, rememberMe: Bool = false, environment: Environment) {
        self.username = username
        self.password = password
        self.twoFactor = twoFactor
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
        if let mfa = twoFactor {
            json[JSONKeys.twoFactor.rawValue] = mfa
        }
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
        case twoFactor = "totp"
        case rememberMe = "rememberMe"
    }
}

extension Login {
    /// `Login` request is specified as a `.post`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest {
        return request(.post)
    }
    
    /// Transform a `Login` request into a `TwoFactorLogin` request
    ///
    /// - parameter token: two factor token to use
    /// - returns: `TwoFactorLogin` struct used to process the request.
    public func twoFactor(token: String) -> Login {
        return Login(username: self.username,
                     password: self.password,
                     twoFactor: token,
                     rememberMe: self.rememberMe,
                     environment: self.environment)
    }
}
