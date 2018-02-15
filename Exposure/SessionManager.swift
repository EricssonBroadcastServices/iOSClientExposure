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
    
    /// Whether to start requests immediately after being constructed. `true` by default.
    public var startRequestsImmediately: Bool = true
    
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
    
    @discardableResult
    public func request<Parameters: Encodable>(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: [String: String]? = nil)
        -> Request
    {
        do {
            let requestUrl = try url.asURL()
            var urlRequest = URLRequest(url: requestUrl)
            urlRequest.httpMethod = method.rawValue
            headers?.forEach{ key, value in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
            
            if let params = parameters {
                let data = try JSONEncoder().encode(params)
                
                
                if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
                urlRequest.httpBody = data
            }
            
            let task = session.dataTask(with: urlRequest)
            let request = Request(session: session, requestTask: task)
            
            delegate[task] = request
            
            if startRequestsImmediately { request.resume() }
            
            return request
        } catch {
            let request = Request(session: session, requestTask: nil, error: error)
            
            if startRequestsImmediately { request.resume() }
            return request
        }
    }
}
