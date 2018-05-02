//
//  SessionDelegate.swift
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
        print(#function,"SessionDelegate")
        print(task.originalRequest?.allHTTPHeaderFields)
        /// Executed after it is determined that the request is not going to be retried
        let completeTask: (URLSession, URLSessionTask, Error?) -> Void = { [weak self] session, task, error in
            print(#function,"completeTask")
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
    
    
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        print(#function)
        
        completionHandler(request)
    }
    
    @available(iOS 11.0, *)
    public func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
        print(#function)
        completionHandler(URLSession.DelayedRequestDisposition.continueLoading,request)
    }
    
//    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        print(#function)
//        completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling,challenge.proposedCredential)
//    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("taskIdentifier",task.taskIdentifier)
        print("sent",bytesSent,"total",totalBytesSent,"expected",totalBytesExpectedToSend)

    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print(#function)
    }
//    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//
//        print("===========")
//        let delegate = self[task]?.delegate
//        print("Data",delegate?.data)
//        print(delegate?.error?.localizedDescription)
//        print(delegate)
//        print("taskIdentifier",task.taskIdentifier)
//        print("-----------")
//        print("previousFailureCount",challenge.previousFailureCount)
//        print("-----------")
//        print("error",challenge.error?.localizedDescription)
//        print("------failureResponse-----")
//        print("debugDescription",challenge.failureResponse.debugDescription)
//        print("mimeType",challenge.failureResponse?.mimeType)
//        print("url",challenge.failureResponse?.url)
//        print("-----protectionSpace------")
//        print(challenge.protectionSpace.authenticationMethod)
//        print(challenge.protectionSpace.host)
//        print(challenge.protectionSpace.port)
//        print(challenge.protectionSpace.protocol)
//        print(challenge.protectionSpace.proxyType)
//        print(challenge.protectionSpace.realm)
//        print("----proposedCredential------")
//        print(challenge.proposedCredential?.password)
//        print(challenge.proposedCredential?.user)
//        print("----Headers------")
//        if let urlResponse = task.response as? HTTPURLResponse {
//            print(urlResponse.allHeaderFields)
//            print(urlResponse.statusCode)
//        }
//
//        if let taskDelegate = self[task]?.delegate {
//            print(taskDelegate.data)
//        }
//        print("===========")
//
//        completionHandler(URLSession.AuthChallengeDisposition.rejectProtectionSpace,nil)
//    }
}


// MARK: - URLSessionDataDelegate

extension SessionDelegate: URLSessionDataDelegate {
    /// Tells the delegate that the data task has received some of the expected data.
    ///
    /// - parameter session:  The session containing the data task that provided data.
    /// - parameter dataTask: The data task that provided data.
    /// - parameter data:     A data object containing the transferred data.
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print(#function)
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
        print(#function)
        self[dataTask]?
            .delegate
            .urlSession(session, dataTask: dataTask, willCacheResponse: proposedResponse, completionHandler: completionHandler)
    }
}
