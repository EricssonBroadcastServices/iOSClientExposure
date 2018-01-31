//
//  AnalyticsBatch.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct AnalyticsBatch: Codable {
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
    public let payload: [AnalyticsEvent]
    
    
    internal enum CodingKeys: CodingKey {
        case sessionToken
        case environment
        case sessionId
        case payload
    }
    public init(sessionToken: SessionToken, environment: Environment, playToken: String, payload: [AnalyticsEvent] = []) {
        self.environment = environment
        self.sessionToken = sessionToken
        self.sessionId = playToken
        self.payload = payload
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        sessionToken = try container.decode(SessionToken.self, forKey: .sessionToken)
        environment = try container.decode(Environment.self, forKey: .environment)
        sessionId = try container.decode(String.self, forKey: .sessionId)
        payload = try container.decode([AnalyticsEvent].self, forKey: .payload)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(sessionToken, forKey: .sessionToken)
        try container.encode(environment, forKey: .environment)
        try container.encode(sessionId, forKey: .sessionId)
        try container.encode(payload, forKey: .payload)
    }
}

extension AnalyticsBatch {
    /// Returns the timestamp in milliseconds (unix epoch time) by which the batch should be sent, or nil if no payload is found
    internal func bufferLimit() -> Int64? {
        return payload
            .map{ $0.timestamp + $0.bufferLimit }
            .sorted{ $0 < $1 }
            .first
    }
}

extension AnalyticsBatch {
    public func jsonParameters() -> [String: Any] {
        return [
            JsonKeys.customer.rawValue: customer,
            JsonKeys.businessUnit.rawValue: businessUnit,
            JsonKeys.sessionId.rawValue: sessionId,
            JsonKeys.payload.rawValue: payload.map{ $0.jsonPayload }
        ]
    }
    
    internal enum JsonKeys: String {
        case customer = "Customer"
        case businessUnit = "BusinessUnit"
        case sessionId = "SessionId"
        case payload = "Payload"
    }
}
