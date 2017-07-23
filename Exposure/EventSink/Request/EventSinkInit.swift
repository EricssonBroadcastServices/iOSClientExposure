//
//  EventSinkInit.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct EventSinkInit{
    public let environment: Environment
    
    internal init(environment: Environment) {
        self.environment = environment
    }
}

extension EventSinkInit: Exposure {
    public typealias Response = AnalyticsConfigResponse
    
    public var endpointUrl: String {
        return environment.baseUrl + "/eventsink/init"
    }
    
    public var parameters: [String: Any]? {
        return nil
    }
    
    public var headers: [String: String]? {
        return nil
    }
}

extension EventSinkInit {
    public func request() -> ExposureRequest {
        return request(.post)
    }
}
