//
//  Exposure.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

public protocol ExposureConvertible {
    init?(json: Any)
}

public protocol JSONEncodable {
    func toJSON() -> [String: Any]
}

public protocol Exposure {
    /// Response type
    associatedtype Response
    
    /// Parameter type
    associatedtype Parameters
    
    /// Header type
    associatedtype Headers
    
    /// Endpoint to contact
    var endpointUrl: String { get }
    
    /// Parameters to include
    var parameters: Parameters { get }
    
    /// Headers to include
    var headers: Headers { get }
}

let sessionManager: SessionManager = {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    return SessionManager(configuration: configuration)
}()

// MARK: - REST API
extension Exposure where Parameters == [String: Any], Headers == HTTPHeaders? {
    
    internal func request(_ method: HTTPMethod, encoding: ParameterEncoding = JSONEncoding.default) -> ExposureRequest {
        let dataRequest = sessionManager
            .request(endpointUrl,
                     method: method,
                     parameters: parameters,
                     encoding: encoding,
                     headers: headers)
        return ExposureRequest(dataRequest: dataRequest)
    }
}


extension Exposure where Parameters == [String: Any]?, Headers == HTTPHeaders? {
    internal func request(_ method: HTTPMethod, encoding: ParameterEncoding = JSONEncoding.default) -> ExposureRequest {
        if let params = parameters {
            let dataRequest = sessionManager
                .request(endpointUrl,
                         method: method,
                         parameters: params,
                         encoding: encoding,
                         headers: headers)
            return ExposureRequest(dataRequest: dataRequest)
        }
        else {
            let dataRequest = sessionManager
                .request(endpointUrl,
                         method: method,
                         headers: headers)
            return ExposureRequest(dataRequest: dataRequest)
        }
    }
}
