//
//  SynchronizeNetworkHandler.swift
//  AnalyticsTests
//
//  Created by Fredrik Sjöberg on 2017-12-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
@testable import Exposure

class SynchronizeNetworkHandler: MockedSuccessNetworkHandler {
    var requestId: String?
    
    static var configJson: [String: Any] {
        return [
            "secondsUntilNextReport": 2,
            "timestampNow": Int((Date().timeIntervalSince1970 * 1000.0).rounded())
        ]
    }
    
    static func configResponse() throws -> AnalyticsConfigResponse {
        let data = try JSONSerialization.data(withJSONObject: SynchronizeNetworkHandler.configJson, options: .prettyPrinted)
        return try JSONDecoder().decode(AnalyticsConfigResponse.self, from: data)
    }
    
    static var initJson: [String: Any] {
        let epoch = Date().millisecondsSince1970
        return [
            "receivedTime": epoch,
            "repliedTime": epoch+SynchronizeNetworkHandler.repliedTime,
            "settings": SynchronizeNetworkHandler.configJson
        ]
    }
    
    static let repliedTime: Int64 = 1000
    static let acceptedDelta: Int64 = 2
    
    static func initResponse() throws -> AnalyticsInitializationResponse {
        let json = SynchronizeNetworkHandler.initJson
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return try JSONDecoder().decode(AnalyticsInitializationResponse.self, from: data)
    }
    
    enum SyncError: Swift.Error {
        case someError
    }
    
    var deliveryReceieved: () -> Void = { _ in }
    var receivedClockDelta: Int64? = nil
    internal func deliver(batch: AnalyticsBatch, clockOffset: Int64?, callback: @escaping (AnalyticsConfigResponse?, ExposureError?) -> Void) {
        receivedClockDelta = abs(SynchronizeNetworkHandler.repliedTime/2+(clockOffset ?? 0))
        deliveryReceieved()
        do {
            let response = try SynchronizeNetworkHandler.configResponse()
            callback(response,nil)
        }
        catch {
            callback(nil, ExposureError.serialization(reason: .jsonSerialization(error: error)))
        }
    }
    
    var failsToSync: Bool = false
    internal func initialize(using environment: Environment, callback: @escaping (AnalyticsInitializationResponse?, ExposureError?) -> Void) {
        if failsToSync {
            callback(nil, ExposureError.generalError(error: SyncError.someError))
        }
        else {
            do {
                let response = try SynchronizeNetworkHandler.initResponse()
                callback(response,nil)
            }
            catch {
                callback(nil, ExposureError.serialization(reason: .jsonSerialization(error: error)))
            }
        }
    }
    
    var payloadDelivered: [AnalyticsEvent] = []
    
    
    init() {
    }
}
