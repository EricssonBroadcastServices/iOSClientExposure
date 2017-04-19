//
//  FetchServerTime.swift
//  Exposure
//
//  Created by Hui Wang on 2017-04-04.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct FetchServerTime: Exposure {
    public typealias Response = ServerTime
    
    public let environment: Environment
    
    public init(environment: Environment) {
        self.environment = environment
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/time"
    }
    
    public var parameters: JSON? {
        return nil
    }
    
    public var headers: [String: String]? {
        return nil
    }
}
