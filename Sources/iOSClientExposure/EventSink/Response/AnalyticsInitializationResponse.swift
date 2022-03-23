//
//  AnalyticsInitializationResponse.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct AnalyticsInitializationResponse: Decodable {
    /// Unix epoch time in milliseconds
    public let receivedTime: Int64?
    
    /// Unix epoch time in milliseconds
    public let repliedTime: Int64?
    
    /// *Exposure* analytics environment data
    public let settings: AnalyticsConfigResponse?
}
