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
    
    public let analytics: AnalyticsFromEntitlement?
    
    public let analyticsBaseUrl: String?

    public let analyticsPercentage: Int?

    public let analyticsPostInterval: Int?
    
    
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
    public var payload: [AnalyticsPayload]
    
    let defaults = UserDefaults.standard
    var sequenceNumber = 0
    let ksequenceNumber: String = "SequenceNumber"
      
    internal enum CodingKeys: CodingKey {
        case sessionToken
        case environment
        case sessionId
        case payload
    }
    public init(sessionToken: SessionToken, environment: Environment, playToken: String, payload: [AnalyticsPayload] = [], analytics: AnalyticsFromEntitlement? = nil, analyticsBaseUrl: String? = nil , analyticsPercentage: Int? = nil , analyticsPostInterval: Int? = nil ) {
        self.environment = environment
        self.sessionToken = sessionToken
        self.sessionId = playToken
        self.payload = payload
        
        self.analytics = analytics
        self.analyticsBaseUrl = analyticsBaseUrl
        self.analyticsPercentage =  analyticsPercentage
        self.analyticsPostInterval = analyticsPostInterval
    }
    
    
    public init?(persistencePayload json: [String: Any]) {
        guard let token = json[PersistenceKeys.sessionToken.rawValue] as? String else { return nil }
        guard let env = json[PersistenceKeys.environment.rawValue] as? [String: String] else { return nil }
        guard let session = json[PersistenceKeys.sessionId.rawValue] as? String else { return nil }
        guard let analyticsBaseUrl = json[PersistenceKeys.analyticsBaseUrl.rawValue] as? String else { return nil }
        
        guard let analyticsPercentage = json[PersistenceKeys.analyticsPercentage.rawValue] as? Int else { return nil }
        guard let analyticsPostInterval = json[PersistenceKeys.analyticsPostInterval.rawValue] as? Int else { return nil }
        
        guard let payloadData = json[PersistenceKeys.payload.rawValue] as? [[String: Any]] else { return nil }
        
        guard let url = env[EnvironmentKeys.url.rawValue],
            let customer = env[EnvironmentKeys.customer.rawValue],
            let businessUnit = env[EnvironmentKeys.businessUnit.rawValue] else { return nil }
        self.environment = Environment(baseUrl: url, customer: customer, businessUnit: businessUnit)
        self.sessionToken = SessionToken(value: token)
        self.sessionId = session
        
        self.analyticsBaseUrl = analyticsBaseUrl
        self.analyticsPercentage = analyticsPercentage
        self.analyticsPostInterval = analyticsPostInterval
        
        self.analytics = nil
        
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
            PersistenceKeys.analyticsBaseUrl.rawValue: analytics?.baseUrl ?? environment.baseUrl,
            PersistenceKeys.analyticsPostInterval.rawValue: analytics?.postInterval ?? 60,
            PersistenceKeys.analyticsPercentage.rawValue: analytics?.percentage ?? 100,
            PersistenceKeys.payload.rawValue: payload.map{ $0.jsonPayload }
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
        
        case payload
    }
    internal enum EnvironmentKeys: String {
        case customer
        case businessUnit
        case url
    }
}

extension AnalyticsBatch {
    /// Returns the timestamp in milliseconds (unix epoch time) by which the batch should be sent, or nil if no payload is found
    internal func bufferLimit() -> Int64? {
        return payload
            .flatMap{ $0 as? AnalyticsEvent }
            .map{ $0.timestamp + $0.bufferLimit }
            .sorted{ $0 < $1 }
            .first
    }
}

extension AnalyticsBatch {
    public mutating func jsonParameters() -> [String: Any] {
       
        var payLoadJson = [[String:Any]]()
        
        var json =  [
            JsonKeys.customer.rawValue: customer,
            JsonKeys.businessUnit.rawValue: businessUnit,
            JsonKeys.sessionId.rawValue: sessionId,
            JsonKeys.analyticsBaseUrl.rawValue : analytics?.baseUrl ?? environment.baseUrl,
            JsonKeys.analyticsPercentage.rawValue : analytics?.percentage ?? 100,
            JsonKeys.analyticsPostInterval.rawValue : analytics?.postInterval ?? 60,
        ] as [String : Any]
        
        for load in payload {
            var updatedjsonLoad = load.jsonPayload

            if let eventType = updatedjsonLoad["EventType"] as? String {
                
                /// Analytics event starting with Playback.Created , so assign sequenceNumber to be 1
                if eventType == "Playback.Created" {
                    sequenceNumber = 1
                    
                    updatedjsonLoad[ksequenceNumber] = sequenceNumber
                    payLoadJson.append(updatedjsonLoad)
                    
                    // Increase the sequenceNumber value by 1 & add it to the default
                    sequenceNumber = sequenceNumber + 1
                    defaults.setValue(sequenceNumber, forKey: ksequenceNumber)
                }
                
                /// Analytics event ends with Playback.Aborted , so assign sequenceNumber to be 0 & remove the value from defaults
                else if (eventType == "Playback.Aborted") {
                    
                    if (isKeyPresentInUserDefaults(key: ksequenceNumber)) {
                        sequenceNumber = defaults.integer(forKey: ksequenceNumber)
                        updatedjsonLoad[ksequenceNumber] = sequenceNumber
                        payLoadJson.append(updatedjsonLoad)
                        sequenceNumber = 0
                        defaults.removeObject(forKey: ksequenceNumber)
                    }
                    
                } else {
                    if (isKeyPresentInUserDefaults(key: ksequenceNumber)) {
                        
                        sequenceNumber = defaults.integer(forKey: ksequenceNumber)
                        updatedjsonLoad[ksequenceNumber] = sequenceNumber
                        payLoadJson.append(updatedjsonLoad)
                        
                        sequenceNumber = sequenceNumber + 1
                        defaults.setValue(sequenceNumber, forKey: ksequenceNumber)
                    }
                }
            }
        }
        
        json[JsonKeys.payload.rawValue] = payLoadJson
        return json
    }
    
    internal enum JsonKeys: String {
        case customer = "Customer"
        case businessUnit = "BusinessUnit"
        case sessionId = "SessionId"
        case payload = "Payload"
        case analytics = "analytics"
        case analyticsBaseUrl = "analyticsBase"
        case analyticsPercentage = "analyticsPercentage"
        case analyticsPostInterval = "analyticsPostInterval"
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
