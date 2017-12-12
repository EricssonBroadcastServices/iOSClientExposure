//
//  AnalyticsBatch.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct AnalyticsBatch {
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
    
    
    public init?(persistencePayload json: [String: Any]) {
        guard let token = json[PersistenceKeys.sessionToken.rawValue] as? String else { return nil }
        guard  let env = json[PersistenceKeys.environment.rawValue] as? [String: String] else { return nil }
        guard    let session = json[PersistenceKeys.sessionId.rawValue] as? String else { return nil }
        guard    let payloadData = json[PersistenceKeys.payload.rawValue] as? [[String: Any]] else { return nil }
        
        guard let url = env[EnvironmentKeys.url.rawValue],
            let customer = env[EnvironmentKeys.customer.rawValue],
            let businessUnit = env[EnvironmentKeys.businessUnit.rawValue] else { return nil }
        self.environment = Environment(baseUrl: url, customer: customer, businessUnit: businessUnit)
        self.sessionToken = SessionToken(value: token)
        self.sessionId = session
        
        self.payload = payloadData.map{ PersistedAnalyticsPayload(payload: $0) }
    }
    
    public var persistencePayload: [String: Any] {
        return [
            PersistenceKeys.sessionToken.rawValue: sessionToken.value,
            PersistenceKeys.environment.rawValue: [
                EnvironmentKeys.businessUnit.rawValue: environment.businessUnit,
                EnvironmentKeys.customer.rawValue: environment.customer,
                EnvironmentKeys.url.rawValue: environment.baseUrl
            ],
            PersistenceKeys.sessionId.rawValue: sessionId,
            PersistenceKeys.payload.rawValue: payload.map{ $0.jsonPayload }
        ]
    }
    
    internal enum PersistenceKeys: String {
        case sessionToken
        case environment
        case sessionId
        case payload
    }
    internal enum EnvironmentKeys: String {
        case customer
        case businessUnit
        case url
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
