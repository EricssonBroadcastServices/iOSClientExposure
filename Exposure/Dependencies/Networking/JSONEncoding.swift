//
//  JsonEncoding.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-02-16.
//  Copyright © 2018 emp. All rights reserved.
//
// Lightweight modification of the Alamofire framework.

//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


import Foundation

public protocol ParameterEncoding {
    func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest
}

public struct JSONEncoding: ParameterEncoding {
    
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
    
    public func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest {
        guard let params = parameters else { return urlRequest }
        var encodedUrlRequest = urlRequest
        
        let data = try JSONSerialization.data(withJSONObject: params, options: [])
        
        if encodedUrlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            encodedUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        encodedUrlRequest.httpBody = data
        
        return encodedUrlRequest
    }
}
