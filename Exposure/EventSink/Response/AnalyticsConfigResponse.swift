//
//  AnalyticsConfigResponse.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Configuration data detailing the *Exposure Analytics Environment* for client applications.
public struct AnalyticsConfigResponse: Decodable {
    /// The requested time untill next contact with the *Analytics Engine*
    public let secondsUntilNextReport: Int64?
    
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
}
