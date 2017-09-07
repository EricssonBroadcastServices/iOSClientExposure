//
//  ExposureRequest.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

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
            let responseBody = SwiftyJSON.JSON(data: data).object
            if let exposureResponse = ExposureResponseMessage(json: responseBody) {
                return ExposureError.exposureResponse(reason: exposureResponse)
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
    public func response<Object: ExposureConvertible>
        (queue: DispatchQueue? = nil,
         completionHandler: @escaping (ExposureResponse<Object>) -> Void) -> Self {
        dataRequest.exposureResponse(queue: queue, mapError: mapError) { (dataResponse: DataResponse<Object>) in
            completionHandler(ExposureResponse(dataResponse: dataResponse))
        }
        return self
    }
}

extension ExposureRequest {
    /// Validates that the response has a status code in the specified sequence.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - parameter range: The range of acceptable status codes.
    /// - returns: The request.
    public func validate<S : Sequence where S.Iterator.Element == Int>(statusCode acceptableStatusCodes: S) -> Self {
        dataRequest.validate(statusCode: acceptableStatusCodes)
        return self
    }
    
    /// Validates that the response has a content type in the specified sequence.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - parameter contentType: The acceptable content types, which may specify wildcard types and/or subtypes.
    /// - returns: The request.
    public func validate<S : Sequence where S.Iterator.Element == String>(contentType acceptableContentTypes: S) -> Self {
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

