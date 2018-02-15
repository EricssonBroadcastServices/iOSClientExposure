//
//  TaskDelegate.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-02-15.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

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
    
    var dataTask: URLSessionDataTask { return task as! URLSessionDataTask }
}
