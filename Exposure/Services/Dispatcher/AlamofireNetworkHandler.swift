//
//  AlamofireNetworkHandler.swift
//  Analytics
//
//  Created by Fredrik Sjöberg on 2017-12-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

internal struct AlamofireNetworkHandler: NetworkHandler {
    func deliver(batch: AnalyticsBatch, clockOffset: Int64?, callback: @escaping (AnalyticsConfigResponse?, ExposureError?) -> Void) {
        EventSink()
            .send(analytics: batch,
                  clockOffset: clockOffset)
            .request()
            .validate()
            .response{ callback($0.value, $0.error) }
    }
    
    func initialize(using environment: Environment, callback: @escaping (AnalyticsInitializationResponse?, ExposureError?) -> Void) {
        EventSink()
            .initialize(using: environment)
            .request()
            .validate()
            .response{ callback($0.value, $0.error) }
    }
}
