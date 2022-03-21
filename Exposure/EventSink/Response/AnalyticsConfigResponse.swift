//
//  AnalyticsConfigResponse.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Configuration data detailing the *Exposure Analytics Environment* for client applications.
public struct AnalyticsConfigResponse: Codable {
    /// The requested time untill next contact with the *Analytics Engine*
    public var secondsUntilNextReport: Int64?
    
    /// If application metrics should  be included when sending payload
    public let includeApplicationMetrics: Bool?
    
    /// If network metrics should  be included when sending payload
    public let includeNetworkMetrics: Bool?
    
    /// If *GPS* metrics should  be included when sending payload
    public let includeGpsMetrics: Bool?
    
    /// If *device* metrics should  be included when sending payload
    public let includeDeviceMetrics: Bool?
    
    /// The current timestamp, in unix epoch time.
    public let timestampNow: Int64?
    
    public init(secondsUntilNextReport: Int64? = nil , includeApplicationMetrics: Bool? = nil , includeNetworkMetrics: Bool? = nil ,includeGpsMetrics: Bool? = nil, includeDeviceMetrics: Bool? = nil ,timestampNow: Int64? = nil ) {
        
        self.secondsUntilNextReport = secondsUntilNextReport
        self.includeApplicationMetrics = includeApplicationMetrics
        self.includeNetworkMetrics = includeNetworkMetrics
        self.includeGpsMetrics = includeGpsMetrics
        self.includeDeviceMetrics = includeDeviceMetrics
        self.timestampNow = timestampNow
    }
}

