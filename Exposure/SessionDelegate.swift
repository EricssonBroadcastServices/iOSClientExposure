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
