//
//  AnalyticsBatch.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct AnalyticsBatch {
    /// MARK: Configuration
    /// Authorization: Bearer "sessionToken"
    public let sessionToken: SessionToken
    
    /// Exposure environment
    public let environment: Environment
    
    /// MARK: Parameters
    /// EMP Customer Group identifier
    public var customer: String {
        return environment.customer
    }
    
    /// EMP Business Unit identifier
    public var businessUnit: String {
        return environment.businessUnit
    }
    
    /// UUID uniquely identifying this playback session.
    public let playToken: String
    
    /// JSON array of analytics events.
    /// Should be sorted on $0.timestamp
    public let payload: [AnalyticsPayload]
}

extension AnalyticsBatch {
    public func toJSON() -> [String: Any] {
        return [
            JSONKeys.customer.rawValue: customer,
            JSONKeys.businessUnit.rawValue: businessUnit,
            JSONKeys.playToken.rawValue: playToken,
            JSONKeys.payload.rawValue: payload.map{ $0.payload }
        ]
    }
    
    internal enum JSONKeys: String {
        case customer = "customer"
        case businessUnit = "businessUnit"
        case playToken = "playToken"
        case payload = "payload"
    }
}
