//
//  AnalyticsBatch.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct AnalyticsBatch: Decodable {
    // MARK: Configuration
    /// Authorization: Bearer "sessionToken"
    public let sessionToken: SessionToken
    
    /// Exposure environment
    public let environment: Environment
    
    // MARK: Parameters
    /// EMP Customer Group identifier
    public var customer: String {
        return environment.customer
    }
    
    /// EMP Business Unit identifier
    public var businessUnit: String {
        return environment.businessUnit
    }
    
    /// UUID uniquely identifying this playback session.
    public let sessionId: String
    
    /// JSON array of analytics events.
    /// Should be sorted on $0.timestamp
    public let payload: [AnalyticsPayload]
    
    
    public init(sessionToken: SessionToken, environment: Environment, playToken: String, payload: [AnalyticsPayload] = []) {
        self.environment = environment
        self.sessionToken = sessionToken
        self.sessionId = playToken
        self.payload = payload
    }
}

extension AnalyticsBatch {
    public func toJSON() -> [String: Any] {
        return [
            JSONKeys.customer.rawValue: customer,
            JSONKeys.businessUnit.rawValue: businessUnit,
            JSONKeys.sessionId.rawValue: sessionId,
            JSONKeys.payload.rawValue: payload.map{ $0.jsonPayload }
        ]
    }
    
    internal enum JSONKeys: String {
        case customer = "Customer"
        case businessUnit = "BusinessUnit"
        case sessionId = "SessionId"
        case payload = "Payload"
    }
}
