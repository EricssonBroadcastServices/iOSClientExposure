//
//  DataRequest.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {
    /// Extends `DataRequest` to enable *Exposure* specific parsing.
    ///
    /// - parameter queue: The queue on which the completion handler is dispatched.
    /// - parameter mapError: The error mapping function to convert between *untyped* `Error` and `ExposureError`.
    /// - parameter completionHandler: The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func exposureResponse<Object: ExposureConvertible>(
        queue: DispatchQueue? = nil,
        mapError: @escaping (Error, Data?) -> ExposureError,
        completionHandler: @escaping (DataResponse<Object>) -> Void)
        -> Self
    {
        let responseSerializer = DataResponseSerializer<Object> {  request, response, data, error in
            guard error == nil else {
                return .failure(mapError(error!, data))
            }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(ExposureError.serialization(reason: .jsonSerialization(error: result.error!)))
            }
            
            guard let object = Object(json: jsonObject) else {
                return .failure(ExposureError.serialization(reason: .objectSerialization(reason: "Unable to serialize object", json: jsonObject)))
            }
            return .success(object)
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
