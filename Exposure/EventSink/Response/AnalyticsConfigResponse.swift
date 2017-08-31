//
//  AnalyticsConfigResponse.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Configuration data detailing the *Exposure Analytics Environment* for client applications.
public struct AnalyticsConfigResponse {
    /// The requested time untill next contact with the *Analytics Engine*
    public let secondsUntilNextReport: Int?
    
    /// If application metrics should  be included when sending payload
    public let includeApplicationMetrics: Bool?
    
    /// If network metrics should  be included when sending payload
    public let includeNetworkMetrics: Bool?
    
    /// If *GPS* metrics should  be included when sending payload
    public let includeGpsMetrics: Bool?
    
    /// If *device* metrics should  be included when sending payload
    public let includeDeviceMetrics: Bool?
    
    /// The current timestamp, in unix epoch time.
    public let timestampNow: Int?
}

extension AnalyticsConfigResponse: ExposureConvertible {
    public init?(json: Any) {
        let actualJSON = JSON(json)
        
        secondsUntilNextReport = actualJSON[JSONKeys.secondsUntilNextReport.rawValue].int
        includeApplicationMetrics = actualJSON[JSONKeys.includeApplicationMetrics.rawValue].bool
        includeNetworkMetrics = actualJSON[JSONKeys.includeNetworkMetrics.rawValue].bool
        includeGpsMetrics = actualJSON[JSONKeys.includeGpsMetrics.rawValue].bool
        includeDeviceMetrics = actualJSON[JSONKeys.includeDeviceMetrics.rawValue].bool
        timestampNow = actualJSON[JSONKeys.timestampNow.rawValue].int
        
        if secondsUntilNextReport == nil && includeApplicationMetrics == nil && includeNetworkMetrics == nil && includeGpsMetrics == nil && includeDeviceMetrics == nil && timestampNow == nil { return nil }
    }
    
    internal enum JSONKeys: String {
        case secondsUntilNextReport = "secondsUntilNextReport"
        case includeApplicationMetrics = "includeApplicationMetrics"
        case includeNetworkMetrics = "includeNetworkMetrics"
        case includeGpsMetrics = "includeGpsMetrics"
        case includeDeviceMetrics = "includeDeviceMetrics"
        case timestampNow = "timestampNow"
    }
}
