//
//  ExposureApi.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-04-03.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

public struct ExposureApi<ResponseType: Decodable>: ExposureType {
    public typealias Response = ResponseType
    
    public var endpointUrl: String {
        return environment.apiUrl + endpoint
    }
    
    fileprivate(set) public var query: String?
    public var parameters: [String: Any]? {
        return query?.components(separatedBy: "&").reduce([String: Any]()) {
            var result = $0
            let comp = $1.components(separatedBy: "=")
            result[comp[0]] = comp[1]
            return result
        }
    }
    public let method: HTTPMethod
    public var headers: [String: String]? {
        return sessionToken?.authorizationHeader
    }
    
    public func request() -> ExposureRequest<ResponseType> {
        let request = sessionManager.request(endpointUrl,
                                             method: method,
                                             parameters: parameters,
                                             headers: headers)
        return ExposureRequest(dataRequest: request)
    }
    
    public let environment: Environment
    public let sessionToken: SessionToken?
    fileprivate let endpoint: String
    
    public init(environment: Environment, endpoint: String, query: String? = nil, method: HTTPMethod = .get, sessionToken: SessionToken? = nil) {
        self.environment = environment
        self.endpoint = endpoint.first == "/" ? endpoint : "/"+endpoint
        self.query = query
        self.method = method
        self.sessionToken = sessionToken
    }
}
