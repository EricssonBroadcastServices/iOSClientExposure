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
    
    public override init() {
        super.init()
    }
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
            strongSelf[task]?.delegate.urlSession(session, task: task, didCompleteWithError: error)
            strongSelf[task] = nil
        }
        
        guard let request = self[task], sessionManager != nil else {
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
    /// Tells the delegate that the data task has received some of the expected data.
    ///
    /// - parameter session:  The session containing the data task that provided data.
    /// - parameter dataTask: The data task that provided data.
    /// - parameter data:     A data object containing the transferred data.
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
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
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        self[dataTask]?
            .delegate
            .urlSession(session, dataTask: dataTask, willCacheResponse: proposedResponse, completionHandler: completionHandler)
    }
}
