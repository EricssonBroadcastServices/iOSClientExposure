//
//  Anonymous.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

/// *Exposure* endpoint integration for handling *Anonymous* login.
public struct Anonymous: ExposureType, Encodable {
    public typealias Response = SessionToken
    
    /// Unique device identifier
    public var deviceId: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    /// Device specific information
    public let device: Device = Device()
    
    /// `Environment` to use
    public let environment: Environment
    
    internal init(environment: Environment) {
        self.environment = environment
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/auth/anonymous"
    }
    
    public var parameters: Anonymous {
        return self
    }
    
    /// `Anonymous` requires no headers
    public var headers: [String: String]? {
        return nil
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(device, forKey: .device)
        try container.encodeIfPresent(deviceId, forKey: .deviceId)
    }
    
    /// Keys used to specify `json` body for the request.
    internal enum CodingKeys: String, CodingKey {
        case deviceId
        case device
    }
}

extension Anonymous {
    /// `Anonymous` request is specified as a `.post`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.post)
    }
}
