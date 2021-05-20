//
//  FirebaseLogin.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2021-05-12.
//  Copyright © 2021 emp. All rights reserved.
//

import Foundation

/// *Exposure* endpoint integration for handling *Firebase* login.
public struct FirebaseLogin: ExposureType, Encodable {
    public typealias Response = Credentials
    
    /// Unique device identifier
    public var deviceId: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    /// Device specific information
    public let device: Device = Device()
    
    /// `Environment` to use
    public let environment: Environment
    
    public let accessToken: String
    
    public let providerId: String
    
    public let username: String?
    public let email: String?
    public let displayName: String?
    
    internal init(environment: Environment, username:String?, email:String?, displayName: String?, accessToken: String, providerId: String) {
        self.environment = environment
        self.accessToken = accessToken
        self.providerId = providerId
        self.username = username
        self.email = email
        self.displayName = displayName
    }

    public var endpointUrl: String {
        var environmentV2 = environment
        environmentV2.version = "v2"
        return environmentV2.apiUrl + "/auth/firebaseLogin"
    }
    
    public var parameters: FirebaseLogin {
        return self
    }
    
    /// `Anonymous` requires no headers
    public var headers: [String: String]? {
        return nil
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(device, forKey: .device)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(providerId, forKey: .providerId)
        try container.encodeIfPresent(username, forKey: .username)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(displayName, forKey: .displayName)
        try container.encode(true, forKey: .emailVerified)
    }
    
    /// Keys used to specify `json` body for the request.
    internal enum CodingKeys: String, CodingKey {

        case device
        case accessToken
        case providerId
        case username
        case email
        case displayName
        case emailVerified
    }
}

extension FirebaseLogin {
    /// `Firebase` request is specified as a `.post`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.post)
    }
}

