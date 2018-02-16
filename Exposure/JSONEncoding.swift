//
//  JsonEncoding.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-02-16.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

public struct JSONEncoding {
    
    public func encode<Parameters: Encodable>(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest {
        guard let params = parameters else { return urlRequest }
        var encodedUrlRequest = urlRequest
        let data = try JSONEncoder().encode(params)
        
        if encodedUrlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            encodedUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        encodedUrlRequest.httpBody = data
        
        return encodedUrlRequest
    }
}
