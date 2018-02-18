//
//  TaskDelegate.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-02-15.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

public class TaskDelegate: NSObject, URLSessionDataDelegate {
    
    // MARK: Properties
    
    /// The serial operation queue used to execute all operations after the task completes.
    public let queue: OperationQueue
    
    /// The data returned by the server.
    public var data: Data? {
        if dataStream != nil {
            return nil
        } else {
            return mutableData
        }
    }
    
    /// The error generated throughout the lifecyle of the task.
    public var error: Error?
    
    var task: URLSessionTask? {
        didSet { reset() }
    }
    
    // MARK: Lifecycle
    
    init(task: URLSessionTask?) {
        self.task = task
        self.mutableData = Data()
        
        self.queue = {
            let operationQueue = OperationQueue()
            
            operationQueue.maxConcurrentOperationCount = 1
            operationQueue.isSuspended = true
            operationQueue.qualityOfService = .utility
            
            return operationQueue
        }()
    }
    
    
    var dataStream: ((_ data: Data) -> Void)?
    
    private var totalBytesReceived: Int64 = 0
    private var mutableData: Data
    
    private var expectedContentLength: Int64?
    
    
    public func reset() {
        error = nil
        
        totalBytesReceived = 0
        mutableData = Data()
        expectedContentLength = nil
    }
    
    var dataTask: URLSessionDataTask { return task as! URLSessionDataTask }
    
    // MARK: URLSessionTaskDelegate
    
    var taskDidCompleteWithError: ((URLSession, URLSessionTask, Error?) -> Void)?
    
    
    @objc(URLSession:task:didCompleteWithError:)
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        if let taskDidCompleteWithError = taskDidCompleteWithError {
//            taskDidCompleteWithError(session, task, error)
//        } else {
//            if let error = error {
//                if self.error == nil { self.error = error }
//            }
//
//            queue.isSuspended = false
//        }
        if let error = error, self.error == nil {
            self.error = error
        }
        
        queue.isSuspended = false
    }
    
    var dataTaskDidReceiveResponse: ((URLSession, URLSessionDataTask, URLResponse) -> URLSession.ResponseDisposition)?
    var dataTaskDidReceiveData: ((URLSession, URLSessionDataTask, Data) -> Void)?
    var dataTaskWillCacheResponse: ((URLSession, URLSessionDataTask, CachedURLResponse) -> CachedURLResponse?)?
    
    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        var disposition: URLSession.ResponseDisposition = .allow
        
        expectedContentLength = response.expectedContentLength
        
        if let dataTaskDidReceiveResponse = dataTaskDidReceiveResponse {
            disposition = dataTaskDidReceiveResponse(session, dataTask, response)
        }
        
        completionHandler(disposition)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let dataTaskDidReceiveData = dataTaskDidReceiveData {
            dataTaskDidReceiveData(session, dataTask, data)
        } else {
            if let dataStream = dataStream {
                dataStream(data)
            } else {
                mutableData.append(data)
            }
            
            let bytesReceived = Int64(data.count)
            totalBytesReceived += bytesReceived
        }
    }
    
    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        willCacheResponse proposedResponse: CachedURLResponse,
        completionHandler: @escaping (CachedURLResponse?) -> Void)
    {
        var cachedResponse: CachedURLResponse? = proposedResponse
        
        if let dataTaskWillCacheResponse = dataTaskWillCacheResponse {
            cachedResponse = dataTaskWillCacheResponse(session, dataTask, proposedResponse)
        }
        
        completionHandler(cachedResponse)
    }
}
