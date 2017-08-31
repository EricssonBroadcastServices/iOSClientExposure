//
//  AnalyticsPayload.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-07-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Defines the `json` payload loadable into an `AnalyticsBatch`
public protocol AnalyticsPayload {
    var jsonPayload: [String: Any] { get }
}
