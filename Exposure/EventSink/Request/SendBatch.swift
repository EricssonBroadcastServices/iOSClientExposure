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
    public var sessionToken: SessionToken {
        return messageBatch.sessionToken
    }
    
    /// Exposure environment
    public var environment: Environment {
        return messageBatch.environment
    }
    
    /// MARK: Parameters
    public let messageBatch: AnalyticsBatch
    
    /// Estimated offset between the device clock and the server clock, in milliseconds. A positive value means that the device is ahead of the server.
    public let clockOffset: Int64?
    
    public init(messageBatch: AnalyticsBatch, clockOffset: Int64? = nil) {
        self.messageBatch = messageBatch
        self.clockOffset = clockOffset
    }
}

extension SendBatch: Exposure {
    public typealias Response = AnalyticsConfigResponse
    
    public var endpointUrl: String {
        return environment.baseUrl + "/eventsink/send"
    }
    
    public var parameters: [String: Any] {
        var event = messageBatch.toJSON()
        
        /// Unix timestamp according to device clock when the batch was sent from the device.
        event[JSONKeys.dispatchTime.rawValue] = Date().millisecondsSince1970
        
        if let clockOffset = clockOffset {
            event[JSONKeys.clockOffset.rawValue] = clockOffset
        }

        return event
    }
    
    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
    
    internal enum JSONKeys: String {
        case dispatchTime = "dispatchTime"
        case clockOffset = "clockOffset"
    }
}

extension SendBatch {
    public func request() -> ExposureRequest {
        return request(.post)
    }
}
