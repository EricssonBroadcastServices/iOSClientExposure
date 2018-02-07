//
//  Request.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-02-06.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

/// Types adopting the `URLConvertible` protocol can be used to construct URLs, which are then used to construct
/// URL requests.
public protocol URLConvertible {
    /// Returns a URL that conforms to RFC 2396 or throws an `Error`.
    ///
    /// - throws: An `Error` if the type cannot be converted to a `URL`.
    ///
    /// - returns: A URL or throws an `Error`.
    func asURL() throws -> URL
}

extension String: URLConvertible {
    /// Returns a URL if `self` represents a valid URL string that conforms to RFC 2396 or throws an `AFError`.
    ///
    /// - throws: An `AFError.invalidURL` if `self` is not a valid URL string.
    ///
    /// - returns: A URL or throws an `AFError`.
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw ExposureError.networking(reason: .invalidUrl(url: self)) }
        return url
    }
}

extension URL: URLConvertible {
    /// Returns self.
    public func asURL() throws -> URL { return self }
}

extension URLComponents: URLConvertible {
    /// Returns a URL if `url` is not nil, otherise throws an `Error`.
    ///
    /// - throws: An `AFError.invalidURL` if `url` is `nil`.
    ///
    /// - returns: A URL or throws an `AFError`.
    public func asURL() throws -> URL {
        guard let url = url else { throw ExposureError.networking(reason: .invalidUrl(url: self)) }
        return url
    }
}

public class SessionManager {
    
    /// A default instance of `SessionManager`, used by top-level Alamofire request methods, and suitable for use
    /// directly for any ad hoc requests.
    public static let `default`: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
//        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
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
        -> DataRequest
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
            let request = DataRequest(session: session, requestTask: task)
            
            delegate[task] = request
            
            if startRequestsImmediately { request.resume() }
            
            return request
        } catch {
            let request = DataRequest(session: session, requestTask: nil, error: error)
            
            if startRequestsImmediately { request.resume() }
            return request
        }
    }
}

public class SessionDelegate: NSObject {
    
    weak var sessionManager: SessionManager?
    
    private var requests: [Int: Request] = [:]
    private let lock = NSLock()
    
    /// Access the task delegate for the specified task in a thread-safe manner.
    public subscript(task: URLSessionTask) -> Request? {
        get {
            lock.lock() ; defer { lock.unlock() }
            return requests[task.taskIdentifier]
        }
        set {
            lock.lock() ; defer { lock.unlock() }
            requests[task.taskIdentifier] = newValue
        }
    }

    /// Initializes the `SessionDelegate` instance.
    ///
    /// - returns: The new `SessionDelegate` instance.
    public override init() {
        super.init()
    }
    
    /// Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:didCompleteWithError:)`.
    open var taskDidComplete: ((URLSession, URLSessionTask, Error?) -> Void)?
}


// MARK: - URLSessionTaskDelegate

extension SessionDelegate: URLSessionTaskDelegate {
    /// Tells the delegate that the task finished transferring data.
    ///
    /// - parameter session: The session containing the task whose request finished transferring data.
    /// - parameter task:    The task whose request finished transferring data.
    /// - parameter error:   If an error occurred, an error object indicating how the transfer failed, otherwise nil.
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        /// Executed after it is determined that the request is not going to be retried
        let completeTask: (URLSession, URLSessionTask, Error?) -> Void = { [weak self] session, task, error in
            guard let strongSelf = self else { return }
            
            strongSelf.taskDidComplete?(session, task, error)
            
            strongSelf[task]?.delegate.urlSession(session, task: task, didCompleteWithError: error)
            
            NotificationCenter.default.post(
                name: Notification.Name.Task.DidComplete,
                object: strongSelf,
                userInfo: [Notification.Key.Task: task]
            )
            
            strongSelf[task] = nil
        }
        
        guard let request = self[task], let sessionManager = sessionManager else {
            completeTask(session, task, error)
            return
        }
        
        // Run all validations on the request before checking if an error occurred
        request.validations.forEach { $0() }
        
        // Determine whether an error has occurred
        var error: Error? = error
        
        if let taskDelegate = self[task]?.delegate, taskDelegate.error != nil {
            error = taskDelegate.error
        }
        
        completeTask(session, task, error)
    }
}

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
        taskDelegate = DataTaskDelegate(task: requestTask)
        
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
            let reason = ExposureError.networking(reason: .unacceptableStatusCode(code: response.statusCode))
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
                let reason = ExposureError.networking(reason: .unacceptableStatusCode(code: response.statusCode))
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
    /// Extends `DataRequest` to enable *Exposure* specific parsing.
    ///
    /// - parameter queue: The queue on which the completion handler is dispatched.
    /// - parameter mapError: The error mapping function to convert between *untyped* `Error` and `ExposureError`.
    /// - parameter completionHandler: The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func response<Object: Decodable>(
        queue: DispatchQueue? = nil,
        mapError: @escaping (Error, Data?) -> ExposureError,
        completionHandler: @escaping (DataResponse<Object>) -> Void)
        -> Self
    {
        let responseSerializer = DataResponseSerializer<Object> { request, response, data, error in
            guard error == nil, let jsonData = data else {
                return .failure(mapError(error!, data))
            }
            
            do {
                let object = try JSONDecoder().decode(Object.self, from: jsonData)
                return .success(object)
            }
            catch let decodingError as DecodingError {
                switch decodingError {
                case .dataCorrupted(let context): return .failure(ExposureError.serialization(reason: .objectSerialization(reason: context.debugDescription, json: jsonData)))
                case .keyNotFound(_, let context): return .failure(ExposureError.serialization(reason: .objectSerialization(reason: context.debugDescription, json: jsonData)))
                case .typeMismatch(_, let context): return .failure(ExposureError.serialization(reason: .objectSerialization(reason: context.debugDescription, json: jsonData)))
                case .valueNotFound(_, let context): return .failure(ExposureError.serialization(reason: .objectSerialization(reason: context.debugDescription, json: jsonData)))
                }
            }
            catch (let e) {
                return .failure(ExposureError.serialization(reason: .objectSerialization(reason: "Unable to serialize object: \(e.localizedDescription)", json: jsonData)))
            }
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

public class DataRequest: Request {
    var dataDelegate: DataTaskDelegate { return delegate as! DataTaskDelegate }
}

public class TaskDelegate: NSObject {
    
    // MARK: Properties
    
    /// The serial operation queue used to execute all operations after the task completes.
    public let queue: OperationQueue
    
    /// The data returned by the server.
    public var data: Data? { return nil }
    
    /// The error generated throughout the lifecyle of the task.
    public var error: Error?
    
    var task: URLSessionTask? {
        didSet { reset() }
    }
    
    // MARK: Lifecycle
    
    init(task: URLSessionTask?) {
        self.task = task
        
        self.queue = {
            let operationQueue = OperationQueue()
            
            operationQueue.maxConcurrentOperationCount = 1
            operationQueue.isSuspended = true
            operationQueue.qualityOfService = .utility
            
            return operationQueue
        }()
    }
    
    func reset() {
        error = nil
    }
    
    // MARK: URLSessionTaskDelegate
    
    var taskDidCompleteWithError: ((URLSession, URLSessionTask, Error?) -> Void)?
    
   
    @objc(URLSession:task:didCompleteWithError:)
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let taskDidCompleteWithError = taskDidCompleteWithError {
            taskDidCompleteWithError(session, task, error)
        } else {
            if let error = error {
                if self.error == nil { self.error = error }
            }
            
            queue.isSuspended = false
        }
    }
}

class DataTaskDelegate: TaskDelegate, URLSessionDataDelegate {
    
    // MARK: Properties
    
    var dataTask: URLSessionDataTask { return task as! URLSessionDataTask }
}

public struct Response<Value> {
    
}
