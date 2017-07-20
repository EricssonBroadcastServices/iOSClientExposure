//
//  SendBatch.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct SendBatch {
    /// MARK: Configuration
    /// Authorization: Bearer "sessionToken"
    public let sessionToken: SessionToken
    
    /// Exposure environment
    public let environment: Environment
    
    
    /// MARK: Parameters
    public let messageBatch: AnalyticsBatch
}

extension SendBatch: Exposure {
    public typealias Response = AnalyticsConfigResponse
    
    public var endpointUrl: String {
        return environment.baseUrl + "/eventsink/send"
    }
    
    public var parameters: [String: Any] {
        return [JSONKeys.messageBatch.rawValue: messageBatch.toJSON]
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
    
    internal enum JSONKeys: String {
        case messageBatch = "messageBatch"
    }
}

extension SendBatch {
    public func request() -> ExposureRequest {
        return request(.post)
    }
}
