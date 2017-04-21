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

public class ExposureRequest {
    internal let dataRequest: DataRequest
    internal var mapError: (Error, Data?) -> ExposureError
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
    
    public func mapError(callback: @escaping (Error, Data?) -> ExposureError) -> Self {
        self.mapError = callback
        return self
    }
}

extension ExposureRequest {
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
    ///
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
    ///
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

