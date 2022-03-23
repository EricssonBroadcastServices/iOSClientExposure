//
//  ExposureApi.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-04-03.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

/// `ExposureApi` is designed as an integration point for querying a generic *Exposure* endpoint.
///
/// Users can specify a generic `ResponseType` (any data structure that conforms to `Decodable`) which will be materialized from the server response. In the event the server responds with an error, this will be handled by error validation and promotion of the related `ExposureError`.
///
/// Queries can be specified in *freeform*.
public struct ExposureApi<ResponseType: Decodable>: ExposureType {
    /// Will be decoded on response
    public typealias Response = ResponseType
    
    /// THe endpoint url
    public var endpointUrl: String {
        return environment.apiUrl + endpoint
    }
    
    /// Raw query to be used when making the response
    fileprivate(set) public var query: String?
    
    /// Parameters in a dictionary format
    public var parameters: [String: Any]?
    
    /// HTTP method to use
    public let method: HTTPMethod
    
    /// Headers to apply
    public var headers: [String: String]? {
        var result: [String: String] = [:]
        
        if let custom = customHeaders {
            custom.forEach{ result[$0] = $1 }
        }
        
        if let authorization = sessionToken?.authorizationHeader {
            authorization.forEach{ result[$0] = $1 }
        }
        
        return result.isEmpty ? nil : result
    }
    
    internal let customHeaders: [String: String]?
    
    /// Performs the actual request
    public func request() -> ExposureRequest<ResponseType> {
        let request = sessionManager.request(endpointUrl,
                                             method: method,
                                             parameters: parameters,
                                             headers: headers)
        return ExposureRequest(dataRequest: request)
    }
    
    /// *Exposure* environment to use
    public let environment: Environment
    
    /// Optional session token to append to the headers
    public let sessionToken: SessionToken?
    
    /// Internal specifier for the *Exposure* endpoint to use
    fileprivate let endpoint: String
    
    /// Initializer
    ///
    /// - parameter environment: The *Exposure* environment to use
    /// - parameter endpoint: The *Exposure* endpoint to contant, for example "/userplayhistory/lastviewed"
    /// - parameter query: An optional query to apply
    /// - parameter method: The HTTP method to apply
    /// - parameter sessionToken: an optional session token to append to the headers
    public init(environment: Environment, endpoint: String, query: String? = nil, method: HTTPMethod = .get, sessionToken: SessionToken? = nil, headers: [String: String]? = nil) {
        self.environment = environment
        self.endpoint = endpoint.first == "/" ? endpoint : "/"+endpoint
        self.query = query
        self.parameters = query?.components(separatedBy: "&").reduce([String: Any]()) {
            guard $1 != "" else { return $0 }
            var result = $0
            let comp = $1.components(separatedBy: "=")
            guard comp.count == 2 else { return $0 }
            result[comp[0]] = comp[1]
            return result
        }
        self.method = method
        self.sessionToken = sessionToken
        self.customHeaders = headers
    }
    
    /// Initializer
    ///
    /// - parameter environment: The *Exposure* environment to use
    /// - parameter endpoint: The *Exposure* endpoint to contant, for example "/userplayhistory/lastviewed"
    /// - parameter query: An optional query to apply
    /// - parameter method: The HTTP method to apply
    /// - parameter sessionToken: an optional session token to append to the headers
    public init(environment: Environment, endpoint: String, parameters: [String: Any], method: HTTPMethod = .get, sessionToken: SessionToken? = nil, headers: [String: String]? = nil) {
        self.environment = environment
        self.endpoint = endpoint.first == "/" ? endpoint : "/"+endpoint
        self.query = nil
        self.parameters = parameters
        self.method = method
        self.sessionToken = sessionToken
        self.customHeaders = headers
    }
}

extension ExposureApi {
    public func request(encoding: ParameterEncoding) -> ExposureRequest<ResponseType> {
        let request = sessionManager.request(endpointUrl,
                                             method: method,
                                             parameters: parameters,
                                             encoding: encoding,
                                             headers: headers)
        return ExposureRequest(dataRequest: request)
    }
    
}
