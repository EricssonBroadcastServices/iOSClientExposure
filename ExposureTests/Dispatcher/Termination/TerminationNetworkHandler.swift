//
//  TerminationNetworkHandler.swift
//  AnalyticsTests
//
//  Created by Fredrik Sjöberg on 2017-12-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
@testable import Exposure


class TerminationNetworkHandler: MockedSuccessNetworkHandler {
    enum TerminationError: Swift.Error {
        case someError
    }
    
    var failsToDispatch: Bool = false
    func deliver(batch: AnalyticsBatch, clockOffset: Int64?, callback: @escaping (AnalyticsConfigResponse?, ExposureError?) -> Void) {
        if failsToDispatch {
            callback(nil, ExposureError.generalError(error: TerminationError.someError))
        }
        else {
            payloadDelivered.append(contentsOf: batch.payload)
            do {
                let response = try TerminationNetworkHandler.configResponse()
                callback(response,nil)
            }
            catch {
                callback(nil, ExposureError.serialization(reason: .jsonSerialization(error: error)))
            }
        }
    }
    
    func initialize(using environment: Environment, callback: @escaping (AnalyticsInitializationResponse?, ExposureError?) -> Void) {
        do {
            let response = try TerminationNetworkHandler.initResponse()
            callback(response,nil)
        }
        catch {
            callback(nil, ExposureError.serialization(reason: .jsonSerialization(error: error)))
        }
    }
    
    var payloadDelivered: [AnalyticsPayload] = []
    
    
    init() {
    }
}
