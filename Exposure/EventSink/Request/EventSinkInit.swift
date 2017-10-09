//
//  EventSinkInit.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// `EventSink` Initialization returns a set of basic data used to configure the *Analytics Environment*
public struct EventSinkInit{
    /// Exposure environment
    public let environment: Environment
    
    internal init(environment: Environment) {
        self.environment = environment
    }
}

extension EventSinkInit: ExposureType {
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
    /// `EventSinkInit` request is specified as a `.post`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest {
        return request(.post)
    }
}
