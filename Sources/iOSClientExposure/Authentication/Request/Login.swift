//
//  Login.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import UIKit

/// *Exposure* endpoint integration for handling *Login* through *username* and *password*.
public struct Login: ExposureType, Encodable {
    public typealias Response = Credentials
    
    /// Username to authenticate with
    public let username: String
    
    /// Password associated with `username`
    public let password: String
    
    /// Two factor token to use
    public let twoFactor: String?
    
    /// `true` extends period of session validity, `false` uses normal validation period.
    public let rememberMe: Bool
    
    /// Unique device identifier
    public var deviceId: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    /// Device specific information
    public let device: Device = Device()
    
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
        var environmentV3 = environment
        environmentV3.version = "v3"
        return environmentV3.apiUrl + "/auth/login"
    }
    
    public var parameters: Login {
        return self
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        try container.encodeIfPresent(twoFactor, forKey: .twoFactor)
        try container.encode(rememberMe, forKey: .rememberMe)
        try container.encode(device, forKey: .device)
    }
    
    /// Keys used to specify `json` body for the request.
    internal enum CodingKeys: String, CodingKey {
        case username
        case password
        case twoFactor = "totp"
        case rememberMe
        case deviceId
        case device
    }
}

extension Login {
    /// `Login` request is specified as a `.post`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
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
