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
    
    
    /// Send analytics events to the server
    /// - Parameters:
    ///   - batch: analytics batch
    ///   - parameters: params
    ///   - headers: headers
    ///   - callback: completion callback
    fileprivate func sendAnalyticsToTheServer(_ batch: AnalyticsBatch, _ parameters: [String : Any], _ headers: [String : String], _ callback:  @escaping (AnalyticsConfigResponse?, ExposureError?) -> Void) {
        
        // Check if there is a custom anlytics base url
        if let analyticsBaseUrl = batch.analytics?.baseUrl {
            
            let url = "\(analyticsBaseUrl)/v2/customer/\(batch.customer)/businessunit/\(batch.businessUnit)/eventsink/send"
            let request = sessionManager.request(url,
                                                 method: .post,
                                                 parameters: parameters,
                                                 encoding: JSONEncoding(),
                                                 headers: headers)
            ExposureRequest<Data>(dataRequest: request)
                .validate()
                .response{
                    if let statusCode = $0.response?.statusCode {
                        if statusCode == 200 {
                            var config = AnalyticsConfigResponse()
                            if let  jsonPayload = batch.payload.first?.jsonPayload, let analyticsPostInterval = jsonPayload["AnalyticsPostInterval"] as? Int {
                                config.secondsUntilNextReport = Int64(analyticsPostInterval)
                                callback(config, nil)
                            } else {
                                callback(config, nil)
                            }
                        } else {
                            callback(nil, $0.error)
                        }
                    } else {
                        callback(nil, $0.error)
                    }
                }
        } else {
            
            // Use `AnalyticsConfigResponse` if it is the old / exposure end point
            let url = "\( batch.environment.baseUrl)/eventsink/send"
            let request = sessionManager.request(url,
                                                 method: .post,
                                                 parameters: parameters,
                                                 encoding: JSONEncoding(),
                                                 headers: headers)
            ExposureRequest<AnalyticsConfigResponse>(dataRequest: request)
                .validate()
                .response{ callback($0.value, $0.error) }
            
        }
    }
    
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
        
        let userdefaults = UserDefaults.standard
        let key = "shouldSendAnalytics"
        
        if userdefaults.bool(forKey: key) == true {
            sendAnalyticsToTheServer(batch, parameters, headers, callback)
        } else {
            // Should not send any analytics
        }
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
