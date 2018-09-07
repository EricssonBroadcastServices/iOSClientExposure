//
//  DispatcherNetworkHandler.swift
//  Analytics
//
//  Created by Fredrik Sjöberg on 2017-12-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

internal protocol DispatcherNetworkHandler {
    var requestId: String? { get set }
    func deliver(batch: AnalyticsBatch, clockOffset: Int64?, callback: @escaping (AnalyticsConfigResponse?, ExposureError?) -> Void)
    func initialize(using environment: Environment, callback: @escaping (AnalyticsInitializationResponse?, ExposureError?) -> Void)
}
