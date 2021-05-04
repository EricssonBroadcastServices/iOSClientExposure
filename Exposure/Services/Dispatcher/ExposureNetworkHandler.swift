//
//  AlamofireNetworkHandler.swift
//  Analytics
//
//  Created by Fredrik Sjöberg on 2017-12-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

internal struct ExposureNetworkHandler: DispatcherNetworkHandler {
    
    internal var requestId: String?
    
    internal var lastSquenceNumber: Int?
    
    func deliver(batch: AnalyticsBatch, clockOffset: Int64?, callback: @escaping (AnalyticsConfigResponse?, ExposureError?) -> Void) {
        var batch = batch
        var parameters = batch.jsonParameters()
        parameters["DispatchTime"] = Date().millisecondsSince1970
        if let clockOffset = clockOffset {
            parameters["ClockOffset"] = clockOffset
        }
        
        var headers = batch.sessionToken.authorizationHeader
        if let requestId = requestId {
            headers["X-Request-Id"] = requestId
        }
        
        let url = batch.environment.baseUrl + "/eventsink/send"
        
        let request = sessionManager.request(url,
                                             method: .post,
                                             parameters: parameters,
                                             encoding: JSONEncoding(),
                                             headers: headers)
        ExposureRequest<AnalyticsConfigResponse>(dataRequest: request)
            .validate()
            .response{ callback($0.value, $0.error) }
    }
    
    func initialize(using environment: Environment, callback: @escaping (AnalyticsInitializationResponse?, ExposureError?) -> Void) {
        
        let url = environment.baseUrl + "/eventsink/init"
        
        let headers = requestId != nil ? ["X-Request-Id": requestId!] : nil
        
        let request = sessionManager.request(url,
                                             method: .post,
                                             headers: headers)
        ExposureRequest<AnalyticsInitializationResponse>(dataRequest: request)
            .validate()
            .response{ callback($0.value, $0.error) }
    }
}
