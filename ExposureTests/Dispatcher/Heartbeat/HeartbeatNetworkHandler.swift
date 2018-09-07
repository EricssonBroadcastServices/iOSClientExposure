//
//  HeartbeatNetworkHandler.swift
//  AnalyticsTests
//
//  Created by Fredrik Sjöberg on 2017-12-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
@testable import Exposure

class HeartbeatNetworkHandler: MockedSuccessNetworkHandler {
    var requestId: String?
    
    func deliver(batch: AnalyticsBatch, clockOffset: Int64?, callback: @escaping (AnalyticsConfigResponse?, ExposureError?) -> Void) {
        let heartbeats = batch.payload.flatMap{ $0 as? MockedHeartbeat }
        heartbeatsDelivered.append(contentsOf: heartbeats)
        payloadDelivered.append(contentsOf: batch.payload)
        do {
            let response = try HeartbeatNetworkHandler.configResponse()
            callback(response,nil)
        }
        catch {
            callback(nil, ExposureError.serialization(reason: .jsonSerialization(error: error)))
        }
    }
    
    func initialize(using environment: Environment, callback: @escaping (AnalyticsInitializationResponse?, ExposureError?) -> Void) {
        do {
            let response = try HeartbeatNetworkHandler.initResponse()
            callback(response,nil)
        }
        catch {
            callback(nil, ExposureError.serialization(reason: .jsonSerialization(error: error)))
        }
    }
    
    var heartbeatsDelivered: [MockedHeartbeat] = []
    var payloadDelivered: [AnalyticsPayload] = []
    
    init() {
    }
}
