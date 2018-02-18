//
//  SessionDelegate.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-02-15.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

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
    
//    /// Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:didCompleteWithError:)`.
//    public var taskDidComplete: ((URLSession, URLSessionTask, Error?) -> Void)?
//
//    // MARK: URLSessionDataDelegate Overrides
//
//    /// Overrides default behavior for URLSessionDataDelegate method `urlSession(_:dataTask:didReceive:completionHandler:)`.
//    public var dataTaskDidReceiveResponse: ((URLSession, URLSessionDataTask, URLResponse) -> URLSession.ResponseDisposition)?
//
//    /// Overrides all behavior for URLSessionDataDelegate method `urlSession(_:dataTask:didReceive:completionHandler:)` and
//    /// requires caller to call the `completionHandler`.
//    public var dataTaskDidReceiveResponseWithCompletion: ((URLSession, URLSessionDataTask, URLResponse, (URLSession.ResponseDisposition) -> Void) -> Void)?
//
//    /// Overrides default behavior for URLSessionDataDelegate method `urlSession(_:dataTask:didReceive:)`.
//    public var dataTaskDidReceiveData: ((URLSession, URLSessionDataTask, Data) -> Void)?
//
//    /// Overrides default behavior for URLSessionDataDelegate method `urlSession(_:dataTask:willCacheResponse:completionHandler:)`.
//    public var dataTaskWillCacheResponse: ((URLSession, URLSessionDataTask, CachedURLResponse) -> CachedURLResponse?)?
//
//    /// Overrides all behavior for URLSessionDataDelegate method `urlSession(_:dataTask:willCacheResponse:completionHandler:)` and
//    /// requires caller to call the `completionHandler`.
//    public var dataTaskWillCacheResponseWithCompletion: ((URLSession, URLSessionDataTask, CachedURLResponse, (CachedURLResponse?) -> Void) -> Void)?
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
            
//            strongSelf.taskDidComplete?(session, task, error)
            
            strongSelf[task]?.delegate.urlSession(session, task: task, didCompleteWithError: error)
            
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


// MARK: - URLSessionDataDelegate

extension SessionDelegate: URLSessionDataDelegate {
//    /// Tells the delegate that the data task received the initial reply (headers) from the server.
//    ///
//    /// - parameter session:           The session containing the data task that received an initial reply.
//    /// - parameter dataTask:          The data task that received an initial reply.
//    /// - parameter response:          A URL response object populated with headers.
//    /// - parameter completionHandler: A completion handler that your code calls to continue the transfer, passing a
//    ///                                constant to indicate whether the transfer should continue as a data task or
//    ///                                should become a download task.
//    public func urlSession(
//        _ session: URLSession,
//        dataTask: URLSessionDataTask,
//        didReceive response: URLResponse,
//        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
//    {
//        guard dataTaskDidReceiveResponseWithCompletion == nil else {
//            dataTaskDidReceiveResponseWithCompletion?(session, dataTask, response, completionHandler)
//            return
//        }
//
//        var disposition: URLSession.ResponseDisposition = .allow
//
//        if let dataTaskDidReceiveResponse = dataTaskDidReceiveResponse {
//            disposition = dataTaskDidReceiveResponse(session, dataTask, response)
//        }
//
//        completionHandler(disposition)
//    }
//
    
    /// Tells the delegate that the data task has received some of the expected data.
    ///
    /// - parameter session:  The session containing the data task that provided data.
    /// - parameter dataTask: The data task that provided data.
    /// - parameter data:     A data object containing the transferred data.
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        if let dataTaskDidReceiveData = dataTaskDidReceiveData {
//            dataTaskDidReceiveData(session, dataTask, data)
//        } else if let delegate = self[dataTask]?.delegate {
//            delegate.urlSession(session, dataTask: dataTask, didReceive: data)
//        }
        self[dataTask]?
            .delegate
            .urlSession(session, dataTask: dataTask, didReceive: data)
    }
    
    /// Asks the delegate whether the data (or upload) task should store the response in the cache.
    ///
    /// - parameter session:           The session containing the data (or upload) task.
    /// - parameter dataTask:          The data (or upload) task.
    /// - parameter proposedResponse:  The default caching behavior. This behavior is determined based on the current
    ///                                caching policy and the values of certain received headers, such as the Pragma
    ///                                and Cache-Control headers.
    /// - parameter completionHandler: A block that your handler must call, providing either the original proposed
    ///                                response, a modified version of that response, or NULL to prevent caching the
    ///                                response. If your delegate implements this method, it must call this completion
    ///                                handler; otherwise, your app leaks memory.
    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        willCacheResponse proposedResponse: CachedURLResponse,
        completionHandler: @escaping (CachedURLResponse?) -> Void)
    {
        self[dataTask]?
            .delegate
            .urlSession(session, dataTask: dataTask, willCacheResponse: proposedResponse, completionHandler: completionHandler)
        
//        guard dataTaskWillCacheResponseWithCompletion == nil else {
//            dataTaskWillCacheResponseWithCompletion?(session, dataTask, proposedResponse, completionHandler)
//            return
//        }
//
//        if let dataTaskWillCacheResponse = dataTaskWillCacheResponse {
//            completionHandler(dataTaskWillCacheResponse(session, dataTask, proposedResponse))
//        } else if let delegate = self[dataTask]?.delegate {
//            delegate.urlSession(
//                session,
//                dataTask: dataTask,
//                willCacheResponse: proposedResponse,
//                completionHandler: completionHandler
//            )
//        } else {
//            completionHandler(proposedResponse)
//        }
    }
}
