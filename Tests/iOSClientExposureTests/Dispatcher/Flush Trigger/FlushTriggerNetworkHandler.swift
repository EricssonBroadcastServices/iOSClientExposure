//
//  FlushTriggerNetworkHandler.swift
//  AnalyticsTests
//
//  Created by Fredrik Sjöberg on 2017-12-18.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
@testable import iOSClientExposure

protocol MockedSuccessNetworkHandler: DispatcherNetworkHandler {
    
}

extension MockedSuccessNetworkHandler {
    static var configJson: [String: Any] {
        return [
            "secondsUntilNextReport": 1,
            "timestampNow": Int((Date().timeIntervalSince1970 * 1000.0).rounded())
        ]
    }
    
    static func configResponse() throws -> AnalyticsConfigResponse {
        let data = try JSONSerialization.data(withJSONObject: Self.configJson, options: .prettyPrinted)
        return try JSONDecoder().decode(AnalyticsConfigResponse.self, from: data)
    }
    
    static var initJson: [String: Any] {
        return [
            "receivedTime": 1000,
            "repliedTime": 1100,
            "settings": Self.configJson
        ]
    }
    
    static func initResponse() throws -> AnalyticsInitializationResponse {
        let json = Self.initJson
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return try JSONDecoder().decode(AnalyticsInitializationResponse.self, from: data)
    }
}

class FlushTriggerNetworkHandler: MockedSuccessNetworkHandler {
    var requestId: String?
    
    enum FlushTriggerError: Swift.Error {
        case generalError
    }
    
    var failedCallback: () -> Void = {  }
    var failForcedFlushTrigger: Bool = false
    func deliver(batch: AnalyticsBatch, clockOffset: Int64?, callback: @escaping (AnalyticsConfigResponse?, ExposureError?) -> Void) {
        
        do {
            if failForcedFlushTrigger {
                print("==== failForcedFlushTrigger","[\(payloadDelivered.count)]")
                failForcedFlushTrigger = false
                failedCallback()
                let error = ExposureError.generalError(error: FlushTriggerError.generalError)
                errorsDelivered.append(error)
                callback(nil,error)
            }
            else {
                payloadDelivered.append(contentsOf: batch.payload)
                print("==== payloadDelivered",batch.payload.count,"[\(payloadDelivered.count)]")
                let response = try FlushTriggerNetworkHandler.configResponse()
                callback(response,nil)
            }
        }
        catch {
            let error = ExposureError.generalError(error: FlushTriggerError.generalError)
            errorsDelivered.append(error)
            callback(nil, ExposureError.serialization(reason: .jsonSerialization(error: error)))
        }
    }
    
    func initialize(using environment: Environment, callback: @escaping (AnalyticsInitializationResponse?, ExposureError?) -> Void) {
        callback(nil,nil)
    }
    
    var errorsDelivered: [ExposureError] = []
    var payloadDelivered: [AnalyticsPayload] = []
    
    
    init() {
    }
}
