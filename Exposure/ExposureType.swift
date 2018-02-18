//
//  ExposureType.swift
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
public protocol ExposureType {
    /// Response type
    associatedtype Response: Decodable
    
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
    
    func request() -> ExposureRequest<Response>
}

/// Ignoring local caches to allways retrieve fresh data.
let sessionManager: SessionManager = {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    return SessionManager(configuration: configuration)
}()

// MARK: - REST API
extension ExposureType where Parameters: Encodable, Headers == [String: String]? {
    public func request(_ method: HTTPMethod) -> ExposureRequest<Response> {
        let dataRequest = sessionManager.request(endpointUrl,
                                                 method: method,
                                                 parameters: parameters,
                                                 headers: headers)
        return ExposureRequest(dataRequest: dataRequest)
    }
}

extension ExposureType where Parameters == [String: Any]?, Headers == [String: String]? {
    public func request(_ method: HTTPMethod, encoding: ParameterEncoding = URLEncoding()) -> ExposureRequest<Response> {
        let dataRequest = sessionManager.request(endpointUrl,
                                                 method: method,
                                                 parameters: parameters,
                                                 encoding: encoding,
                                                 headers: headers)
        return ExposureRequest(dataRequest: dataRequest)
    }
}

extension ExposureType where Parameters == [String: Any], Headers == [String: String]? {
    public func request(_ method: HTTPMethod, encoding: ParameterEncoding = URLEncoding()) -> ExposureRequest<Response> {
        let dataRequest = sessionManager.request(endpointUrl,
                                                 method: method,
                                                 parameters: parameters,
                                                 encoding: encoding,
                                                 headers: headers)
        return ExposureRequest(dataRequest: dataRequest)
    }
}
