//
//  RelatedAnalyticsNetworkHandler.swift
//  AnalyticsTests
//
//  Created by Fredrik Sjöberg on 2017-12-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
@testable import Exposure

class RelatedAnalyticsNetworkHandler: MockedSuccessNetworkHandler {
    
    enum RelatedError: Swift.Error {
        case someError
    }
    
    enum DeliveryResult {
        case success
        case failsWithInvalidSessionToken
    }
    var deliveryResult = DeliveryResult.success
    func deliver(batch: AnalyticsBatch, clockOffset: Int64?, callback: @escaping (AnalyticsConfigResponse?, ExposureError?) -> Void) {
        switch deliveryResult {
        case .success:
            do {
                payloadDelivered.append(contentsOf: batch.payload)
                print("RelatedAnalyticsNetworkHandler DELIVERED:",batch.sessionId,payloadDelivered.count)
                let response = try SynchronizeNetworkHandler.configResponse()
                callback(response,nil)
            }
            catch {
                callback(nil, ExposureError.serialization(reason: .jsonSerialization(error: error)))
            }
        case .failsWithInvalidSessionToken:
            print("failsWithInvalidSessionToken",batch.sessionId,batch.payload)
            deliveryResult = .success
            do {
                let response = try RelatedAnalyticsNetworkHandler.invalidSessionTokenResponse()
                callback(nil, ExposureError.exposureResponse(reason: response))
            }
            catch {
                let error = ExposureError.generalError(error: RelatedError.someError)
                callback(nil, ExposureError.serialization(reason: .jsonSerialization(error: error)))
            }
        }
    }
    
    static var invalidSessionTokenJson: [String: Any] {
        return [
            "httpCode": 401,
            "message": "INVALID_SESSION_TOKEN"
        ]
    }
    
    static func invalidSessionTokenResponse() throws -> ExposureResponseMessage {
        let data = try JSONSerialization.data(withJSONObject: RelatedAnalyticsNetworkHandler.invalidSessionTokenJson, options: .prettyPrinted)
        return try JSONDecoder().decode(ExposureResponseMessage.self, from: data)
    }
    
    func initialize(using environment: Environment, callback: @escaping (AnalyticsInitializationResponse?, ExposureError?) -> Void) {
        do {
            let response = try SynchronizeNetworkHandler.initResponse()
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
