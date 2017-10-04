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
public struct Anonymous: ExposureType {
    public typealias Response = SessionToken
    
    /// `DeviceInfo` required by *Exposure*
    public let deviceInfo: DeviceInfo = DeviceInfo()
    
    /// `Environment` to use
    public let environment: Environment
    
    internal init(environment: Environment) {
        self.environment = environment
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/auth/anonymous"
    }
    
    
    public var parameters: [String: Any] {
        return deviceInfo.toJSON()
    }
    
    /// `Anonymous` requires no headers
    public var headers: [String: String]? {
        return nil
    }
}

extension Anonymous {
    /// `Anonymous` request is specified as a `.post`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest {
        return request(.post)
    }
}
