//
//  SessionManager.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-02-15.
//  Copyright © 2018 emp. All rights reserved.
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
    
    public init(
        configuration: URLSessionConfiguration = URLSessionConfiguration.default,
        delegate: SessionDelegate = SessionDelegate())
    {
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
    
    func finalize(encodedRequest: URLRequest) -> Request {
        let task = session.dataTask(with: encodedRequest)
        let request = Request(session: session, requestTask: task)
        
        delegate[task] = request
        
        request.resume()
        return request
    }
    
    @discardableResult
    public func request<Parameters: Encodable>(_ url: URLConvertible,  method: HTTPMethod = .get, parameters: Parameters? = nil, headers: [String: String]? = nil) -> Request {
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
    public func request(_ url: URLConvertible,  method: HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding, headers: [String: String]? = nil) -> Request {
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
