//
//  Request.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-02-06.
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

/// `Request` that manages an underlying `URLSessionDataTask`.
public class Request {
    
    /// The delegate for the underlying task.
    public internal(set) var delegate: TaskDelegate {
        get {
            taskDelegateLock.lock() ; defer { taskDelegateLock.unlock() }
            return taskDelegate
        }
        set {
            taskDelegateLock.lock() ; defer { taskDelegateLock.unlock() }
            taskDelegate = newValue
        }
    }
    
    /// The underlying task.
    public var task: URLSessionTask? { return delegate.task }
    
    /// The session belonging to the underlying task.
    public let session: URLSession
    
    /// The request sent or to be sent to the server.
    public var request: URLRequest? { return task?.originalRequest }
    
    /// The response received from the server, if any.
    public var response: HTTPURLResponse? { return task?.response as? HTTPURLResponse }
    
    
    var validations: [() -> Void] = []
    
    private var taskDelegate: TaskDelegate
    private var taskDelegateLock = NSLock()
    
    // MARK: Lifecycle
    
    init(session: URLSession, requestTask: URLSessionTask?, error: Error? = nil) {
        self.session = session
        taskDelegate = TaskDelegate(task: requestTask)
        
        delegate.error = error
    }
    
    // MARK: State
    
    /// Resumes the request.
    public func resume() {
        guard let task = task else { delegate.queue.isSuspended = false ; return }
        
        task.resume()
    }
    
    /// Suspends the request.
    public func suspend() {
        guard let task = task else { return }
        
        task.suspend()
    }
    
    /// Cancels the request.
    public func cancel() {
        guard let task = task else { return }
        
        task.cancel()
    }
}

extension Request {
    /// Used to represent whether validation was successful or encountered an error resulting in a failure.
    ///
    /// - success: The validation was successful.
    /// - failure: The validation failed encountering the provided error.
    public enum ValidationResult {
        case success
        case failure(Error)
    }
    
    // MARK: Properties
    
    fileprivate var acceptableStatusCodes: [Int] { return Array(200..<300) }
    
    
    // MARK: Status Code
    
    fileprivate func validate<S: Sequence>(
        statusCode acceptableStatusCodes: S,
        response: HTTPURLResponse)
        -> ValidationResult
        where S.Iterator.Element == Int
    {
        if acceptableStatusCodes.contains(response.statusCode) {
            return .success
        } else {
            let reason = Networking.unacceptableStatusCode(code: response.statusCode)
            return .failure(reason)
        }
    }
    
    /// Validates the request, using the specified closure.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - parameter validation: A closure to validate the request.
    ///
    /// - returns: The request.
    @discardableResult
    public func validate(_ validation: @escaping (URLRequest?, HTTPURLResponse, Data?) -> ValidationResult) -> Self {
        let validationExecution: () -> Void = { [unowned self] in
            if
                let response = self.response,
                self.delegate.error == nil,
                case let .failure(error) = validation(self.request, response, self.delegate.data)
            {
                self.delegate.error = error
            }
        }
        
        validations.append(validationExecution)
        
        return self
    }
    
    /// Validates that the response has a status code in the specified sequence.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - parameter range: The range of acceptable status codes.
    ///
    /// - returns: The request.
    @discardableResult
    public func validate<S: Sequence>(statusCode acceptableStatusCodes: S) -> Self where S.Iterator.Element == Int {
        return validate { _, response, _ in
            if acceptableStatusCodes.contains(response.statusCode) {
                return .success
            } else {
                let reason =  Networking.unacceptableStatusCode(code: response.statusCode)
                return .failure(reason)
            }
        }
    }
    /// Validates that the response has a status code in the default acceptable range of 200...299, and that the content
    /// type matches any specified in the Accept HTTP header field.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - returns: The request.
    @discardableResult
    public func validate() -> Self {
        return validate(statusCode: self.acceptableStatusCodes)
    }
}

extension Request {
    
    public enum Networking: Error {
        case invalidUrl(url: URLConvertible)
        case unacceptableStatusCode(code: Int)
        case noResponseData
        case parameterEncodingFailedMissingUrl
        
        public var message: String {
            switch self {
            case .invalidUrl(url: let url): return "Invalid URL in URLConvertible \(url)"
            case .unacceptableStatusCode(code: let code): return "Unacceptable status code \(code) in http response"
            case .noResponseData: return "Response data was null"
            case .parameterEncodingFailedMissingUrl: return "URLRequest is missing an url to encode parameters onto"
            }
        }
    }
    
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:              The queue on which the completion handler is dispatched.
    /// - parameter responseSerializer: The response serializer responsible for serializing the request, response,
    ///                                 and data.
    /// - parameter completionHandler:  The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func response<Object: Decodable>(queue: DispatchQueue? = nil, responseSerializer: @escaping (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Result<Object>, completionHandler: @escaping (Response<Object>) -> Void) -> Self {
        delegate.queue.addOperation {
            print(#function)
            let result = responseSerializer(self.request,
                                            self.response,
                                            self.delegate.data,
                                            self.delegate.error)
            
            
            let dataResponse = Response(request: self.request,
                                        response: self.response,
                                        data: self.delegate.data,
                                        result: result)
            (queue ?? DispatchQueue.main).async {
                completionHandler(dataResponse)
            }
        }
        return self
    }
    
    /// Adds a handler with a default JSONSerializer to be called once the request has finished.
    ///
    /// - parameter queue:              The queue on which the completion handler is dispatched.
    /// - parameter completionHandler:  The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func response<Object: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (Response<Object>) -> Void) -> Self {
        let responseSerializer: (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Result<Object> = { request, response, data, error in
            guard error == nil, let jsonData = data else {
                return .failure(error: error!)
            }
            
            do {
                let object = try JSONDecoder().decode(Object.self, from: jsonData)
                return .success(value: object)
            }
            catch (let e) {
                return .failure(error: e)
            }
        }
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    
    /// Adds a handler which does no response serialization to be called once the request has finished.
    ///
    /// - parameter queue:              The queue on which the completion handler is dispatched.
    /// - parameter completionHandler:  The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func rawResponse(queue: DispatchQueue? = nil, completionHandler: @escaping (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Void) -> Self {
        delegate.queue.addOperation {
            (queue ?? DispatchQueue.main).async {
                completionHandler(self.request, self.response, self.delegate.data, self.delegate.error)
            }
        }
        return self
    }
}

