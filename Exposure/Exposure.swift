//
//  Exposure.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

public protocol Serializable: Encodable {
    func toJSON() -> [String: Any]
}

extension Serializable {
    public func toJSON() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                as? [String: Any] else { return [:] }
        return json ?? [:]
    }
}

/// Base protocol detailing the structure required interact with *Exposure*.
///
/// All requests to *Exposure* should adhere to this format.
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

/// Ignoring local caches to allways retrieve fresh data.
let sessionManager: SessionManager = {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    return SessionManager(configuration: configuration)
}()

// MARK: - REST API
extension Exposure where Parameters == [String: Any], Headers == HTTPHeaders? {
    /// Convenience method for making *Exposure* requests with a set of parameters and optional headers
    ///
    /// - parameter method: `Alamofire` specified `HTTPMethod`
    /// - parameter encoding: Parameter encoding to use
    /// - returns: `ExposureRequest` encapsulating the request to make
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
    /// Convenience method for making *Exposure* requests with an optional set of parameters and headers
    ///
    /// - parameter method: `Alamofire` specified `HTTPMethod`
    /// - parameter encoding: Parameter encoding to use
    /// - returns: `ExposureRequest` encapsulating the request to make
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
