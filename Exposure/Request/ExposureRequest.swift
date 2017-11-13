//
//  ExposureRequest.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

/// Responsible for sending a request and receiving response from the server.
///
/// Errors are mapped to typed *ExposureErrors* by default. Specialized error handling can be performed through the `mapError(callback:)` function.
public class ExposureRequest {
    /// Internally handled by Alamofire
    internal let dataRequest: DataRequest
    
    /// Error mapping function where `error` and `data` are mapped to an `ExposureError`.
    internal var mapError: (Error, Data?) -> ExposureError
    
    /// Default error mapper tries to materialize an `ExposureResponseMessage` from the response `Data` if (and only if) an `Error` occured. Failure to do so will forward the `generalError`.
    internal init(dataRequest: DataRequest,
                  mapError: @escaping (Error, Data?) -> ExposureError = { (error, data) in
        if let data = data {
            // Handle status code errors from Exposure
            do {
                let exposureResponse = try JSONDecoder().decode(ExposureResponseMessage.self, from: data)
                return ExposureError.exposureResponse(reason: exposureResponse)
            } catch (let error) {
                return ExposureError.generalError(error: error)
            }
        }
        return ExposureError.generalError(error: error)
        }) {
        self.dataRequest = dataRequest
        self.mapError = mapError
    }
    
    /// Customize the error mapping function
    ///
    /// - parameter callback: Callback to perform the error mapping
    /// - returns: `Self`
    public func mapError(callback: @escaping (Error, Data?) -> ExposureError) -> Self {
        self.mapError = callback
        return self
    }
}

extension ExposureRequest {
    /// Response materialization.
    ///
    /// Once the request has been created, calling this method will trigger the request and materialize the response.
    ///
    /// - parameter queue: The queue on which the completion handler is dispatched.
    /// - parameter completionHandler: The code to be executed once the request has finished.
    /// - returns: `Self`
    @discardableResult
    public func response<Object>
        (queue: DispatchQueue? = nil,
         completionHandler: @escaping (ExposureResponse<Object>) -> Void) -> Self {
        dataRequest.exposureResponse(queue: queue, mapError: mapError) { (dataResponse: DataResponse<Object>) in
            completionHandler(ExposureResponse(dataResponse: dataResponse))
        }
        return self
    }
    
    /// Response materialization.
    ///
    /// Once the request has been created, calling this method will trigger the request and materialize the response.
    ///
    /// - parameter queue: The queue on which the completion handler is dispatched.
    /// - parameter completionHandler: The code to be executed once the request has finished.
    /// - returns: `Self`
    @discardableResult
    public func response
        (queue: DispatchQueue? = nil,
         completionHandler: @escaping (ExposureError?) -> Void) -> Self {
        dataRequest.emptyExposureResponse(queue: queue, mapError: mapError) { (dataResponse: DataResponse<Data>) in
            completionHandler(ExposureResponse(dataResponse: dataResponse).error)
        }
        return self
    }
}

extension ExposureRequest {
    // MARK: State
    
    /// Resumes the request.
    open func resume() {
        dataRequest.resume()
    }
    
    /// Suspends the request.
    open func suspend() {
        dataRequest.suspend()
    }
    
    /// Cancels the request.
    open func cancel() {
        dataRequest.cancel()
    }
}

extension ExposureRequest {
    /// Validates that the response has a status code in the specified sequence.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - parameter range: The range of acceptable status codes.
    /// - returns: The request.
    public func validate<S : Sequence>(statusCode acceptableStatusCodes: S) -> Self where S.Iterator.Element == Int {
        dataRequest.validate(statusCode: acceptableStatusCodes)
        return self
    }
    
    /// Validates that the response has a content type in the specified sequence.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - parameter contentType: The acceptable content types, which may specify wildcard types and/or subtypes.
    /// - returns: The request.
    public func validate<S : Sequence>(contentType acceptableContentTypes: S) -> Self where S.Iterator.Element == String {
        dataRequest.validate(contentType: acceptableContentTypes)
        return self
    }
    
    /// Validates that the response has a status code in the default acceptable range of 200...299, and that the content
    /// type matches any specified in the Accept HTTP header field.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - returns: The request.
    public func validate() -> Self {
        dataRequest.validate()
        return self
    }
}

