//
//  SessionManager.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-02-15.
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

public class SessionManager {
    
    public static let `default`: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        return SessionManager(configuration: configuration)
    }()
    
    
    /// The underlying session.
    public let session: URLSession
    
    /// The session delegate handling all the task and session delegate callbacks.
    public let delegate: SessionDelegate
    
    public init( configuration: URLSessionConfiguration = URLSessionConfiguration.default, delegate: SessionDelegate = SessionDelegate()) {
        self.delegate = delegate
        self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        
        self.delegate.sessionManager = self
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    private func createRequest(from url: URLConvertible,  method: HTTPMethod = .get, headers: [String: String]? = nil) throws -> URLRequest {
        let requestUrl = try url.asURL()
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = method.rawValue
        headers?.forEach{ key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        return urlRequest
    }
    
    private func finalize(encodedRequest: URLRequest) -> Request {
        let task = session.dataTask(with: encodedRequest)
        let request = Request(session: session, requestTask: task)
        
        delegate[task] = request
        
        request.resume()
        return request
    }
    
    @discardableResult
    public func request(_ url: URLConvertible,  method: HTTPMethod = .get, data: Data, headers: [String: String]? = nil) -> Request {
        do {
            var encodedUrlRequest = try createRequest(from: url, method: method, headers: headers)
            encodedUrlRequest.httpBody = data
            return finalize(encodedRequest: encodedUrlRequest)
        } catch {
            let request = Request(session: session, requestTask: nil, error: error)
            
            request.resume()
            return request
        }
    }
    
    @discardableResult
    public func request<Parameters: Encodable>(_ url: URLConvertible,  method: HTTPMethod = .get, parameters: Parameters, headers: [String: String]? = nil) -> Request {
        do {
            let urlRequest = try createRequest(from: url, method: method, headers: headers)
            let encodedRequest = try JSONEncoding().encode(urlRequest, with: parameters)
            return finalize(encodedRequest: encodedRequest)
        } catch {
            let request = Request(session: session, requestTask: nil, error: error)
            
            request.resume()
            return request
        }
    }
    
    @discardableResult
    public func request(_ url: URLConvertible,  method: HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding(), headers: [String: String]? = nil) -> Request {
        do {
            let urlRequest = try createRequest(from: url, method: method, headers: headers)
            let encodedRequest = try encoding.encode(urlRequest, with: parameters)
            return finalize(encodedRequest: encodedRequest)
        } catch {
            let request = Request(session: session, requestTask: nil, error: error)
            
            request.resume()
            return request
        }
    }
    
}
