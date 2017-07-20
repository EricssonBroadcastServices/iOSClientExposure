//
//  AnalyticsConfigResponse.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct AnalyticsConfigResponse {
    let secondsUntilNextReport: Int?
    let includeApplicationMetrics: Bool?
    let includeNetworkMetrics: Bool?
    let includeGpsMetrics: Bool?
    let includeDeviceMetrics: Bool?
    let timestampNow: Int?
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
