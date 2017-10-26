//
//  FetchServerTime.swift
//  Exposure
//
//  Created by Hui Wang on 2017-04-04.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Request *server time*. This may be used to detect client clock drift or simply synchronizing client and server timestamps.
public struct FetchServerTime: ExposureType {
    public typealias Response = ServerTime
    
    /// `Environment` to use
    public let environment: Environment
    
    public init(environment: Environment) {
        self.environment = environment
    }
    
    public var endpointUrl: String {
        return environment.apiUrl + "/time"
    }
    
    public var parameters: [String: Any]? {
        return nil
    }
    
    public var headers: [String: String]? {
        return nil
    }
}

extension FetchServerTime {
    /// `FetchServerTime` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest {
        return request(.get)
    }
}
