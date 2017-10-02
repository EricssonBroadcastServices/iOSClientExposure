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
    public let payload: [AnalyticsPayload]
    
    
    public init(sessionToken: SessionToken, environment: Environment, playToken: String, payload: [AnalyticsPayload] = []) {
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
        payload = try container.decode([PersistedAnalyticsPayload].self, forKey: .payload)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(sessionToken, forKey: .sessionToken)
        try container.encode(environment, forKey: .environment)
        try container.encode(sessionId, forKey: .sessionId)
        try container.encode(payload, forKey: .payload)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case sessionToken
        case environment
        case sessionId
        case payload
    }
}

extension AnalyticsBatch {
    public func jsonParameters() -> [String: Any] {
        return [
            PayloadKeys.customer.rawValue: customer,
            PayloadKeys.businessUnit.rawValue: businessUnit,
            PayloadKeys.sessionId.rawValue: sessionId,
            PayloadKeys.payload.rawValue: payload.map{ $0.jsonPayload }
        ]
    }
    
    internal enum PayloadKeys: String {
        case customer = "Customer"
        case businessUnit = "BusinessUnit"
        case sessionId = "SessionId"
        case payload = "Payload"
    }
}


/// Convenience struct used to realize persisted `AnalyticsPayload` represented as *JSON*.
/// This is basicly a wrapper around the *JSON* payload that conforms to `AnalyticsPayload` to enable quick integration.
internal struct PersistedAnalyticsPayload: AnalyticsPayload, Decodable {
    /// Internal *JSON* representation
    private let jsonRepresentation: [String: AnyJSONType]
    
    //    /// Convenience initializer for decoding *persisted* `AnalyticsPayload` objects.
    //    ///
    //    /// - parameter persistenceJson: *JSON* object
    //    internal init?(persistenceJson: Any) {
    //        guard let json = persistenceJson as? [String: Any] else { return nil }
    //        jsonRepresentation = json
    //    }
    
    /// `AnalyticsPayload` conformance
    internal var jsonPayload: [String : Any] {
        return jsonRepresentation
    }
}
