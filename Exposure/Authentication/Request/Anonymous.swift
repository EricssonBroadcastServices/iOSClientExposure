//
//  Anonymous.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Anonymous: Exposure {
    public typealias Response = SessionToken
    
    public let deviceInfo: DeviceInfo = DeviceInfo()
    public let environment: Environment
    
    public init(environment: Environment) {
        self.environment = environment
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/auth/anonymous"
    }
    
    public var parameters: [String: Any] {
        return deviceInfo.toJSON()
    }
    
    public var headers: [String: String]? {
        return nil
    }
}
