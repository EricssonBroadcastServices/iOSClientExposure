//
//  OfflineAnalyticsBatch.swift
//  
//
//  Created by Udaya Sri Senarathne on 2023-07-02.
//

import Foundation



/// OfflineAnalyticsBatch
public struct OfflineAnalyticsBatch {
    
    public let assetId: String
    
    public var analyticsBatch: [AnalyticsBatch]
    
    public var payload: [AnalyticsPayload]
    
    public let sessionToken: SessionToken
    
    public let environment: Environment
    
    public let analytics: AnalyticsFromEntitlement?
    
    public let analyticsBaseUrl: String?
    
    public var customer: String {
        return environment.customer
    }
    
    public var businessUnit: String {
        return environment.businessUnit
    }
    
    public let sessionId: String
    
    let defaults = UserDefaults.standard
    
    // Starting the sequence with 1
    var sequenceNumber:Int
    let ksequenceNumber: String = "SequenceNumber"
    
    internal enum CodingKeys: CodingKey {
        case sessionToken
        case environment
        case sessionId
        case analyticsBatch
        case assetId
        case playload
    }
    
    public init(assetId: String, analyticsBatch: [AnalyticsBatch], sessionToken: SessionToken, environment: Environment, playToken: String, analytics: AnalyticsFromEntitlement? = nil, analyticsBaseUrl: String? = nil, payload: [AnalyticsPayload], sequenceNumber: Int ) {
        
        
        self.assetId = assetId
        self.analyticsBatch = analyticsBatch
        
        self.environment = environment
        self.sessionToken = sessionToken
        self.sessionId = playToken
        
        self.analytics = analytics
        self.analyticsBaseUrl = analyticsBaseUrl
        self.sequenceNumber = sequenceNumber
        
        self.payload = payload
        
    }
    
    public init?(persistencePayload json: [String: Any]) {
        
        guard let assetId = json[PersistenceKeys.assetId.rawValue] as? String else { return nil }
        
        guard let token = json[PersistenceKeys.sessionToken.rawValue] as? String else { return nil }
        guard let env = json[PersistenceKeys.environment.rawValue] as? [String: String] else { return nil }
        guard let analyticsBaseUrl = json[PersistenceKeys.analyticsBaseUrl.rawValue] as? String else { return nil }
        guard let sequenceNumber = json[PersistenceKeys.sequenceNumber.rawValue] as? Int else { return nil }
        guard let playToken = json[PersistenceKeys.sessionId.rawValue] as? String else { return nil }
        
        guard let payloadData = json[PersistenceKeys.payload.rawValue] as? [[String: Any]] else { return nil }
        
        guard let sessions = json[PersistenceKeys.sessions.rawValue] as? [AnalyticsBatch] else { return nil }
        
        
        guard let url = env[EnvironmentKeys.url.rawValue],
              let customer = env[EnvironmentKeys.customer.rawValue],
              let businessUnit = env[EnvironmentKeys.businessUnit.rawValue] else { return nil }
        self.environment = Environment(baseUrl: url, customer: customer, businessUnit: businessUnit)
        self.sessionToken = SessionToken(value: token)
        self.sessionId = playToken
        
        self.analyticsBaseUrl = analyticsBaseUrl
        
        self.analytics = nil
        
        self.assetId = assetId
        self.analyticsBatch =  sessions
        
        self.sequenceNumber = sequenceNumber
        
        self.payload = payloadData.map{ PersistedAnalyticsPayload(payload: $0) }
    }
    
    public var persistencePayload: [String: Any] {
        return [
            
            PersistenceKeys.assetId.rawValue: assetId,
            PersistenceKeys.sessions.rawValue: [
                [
                    
                    
                    PersistenceKeys.sessionToken.rawValue: sessionToken.value,
                    PersistenceKeys.environment.rawValue: [
                        EnvironmentKeys.businessUnit.rawValue: environment.businessUnit,
                        EnvironmentKeys.customer.rawValue: environment.customer,
                        EnvironmentKeys.url.rawValue: environment.baseUrl
                    ],
                    
                    // Initial sequence number value will be 1
                    PersistenceKeys.sessionId.rawValue : "\(sessionId)_\(sequenceNumber)",
                    PersistenceKeys.sequenceNumber.rawValue: sequenceNumber,
                    PersistenceKeys.analyticsBaseUrl.rawValue: analytics?.baseUrl ?? environment.baseUrl,
                    PersistenceKeys.analyticsPostInterval.rawValue: analytics?.postInterval ?? 60, // This value will not be used for offline analytics , but add it to keep the same structure as regular analytics
                    PersistenceKeys.analyticsPercentage.rawValue: analytics?.percentage ?? 100, // // This value will not be used for offline analytics , but add it to keep the same structure as regular analytics
                    PersistenceKeys.payload.rawValue: payload.map{ $0.jsonPayload }
                ] as [String : Any]
            ]
        ]
    }
    
    
    
    public var persistenceEnviornmentPayload: [String: Any] {
        return [
            EnvironmentKeys.businessUnit.rawValue: environment.businessUnit,
            EnvironmentKeys.customer.rawValue: environment.customer,
            EnvironmentKeys.url.rawValue: environment.baseUrl
        ]
    }
    
    internal enum PersistenceKeys: String {
        case sessionToken
        case environment
        
        case sessionId
        
        case analytics
        case analyticsBaseUrl
        case analyticsPostInterval
        case analyticsPercentage
        
        case analyticsBatch
        case assetId
        case sequenceNumber
        case payload
        
        case sessions
        
    }
    
    internal enum EnvironmentKeys: String {
        case customer
        case businessUnit
        case url
    }
    
    
}
