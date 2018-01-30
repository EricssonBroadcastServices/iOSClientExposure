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
    public func exposureResponse<Object: Decodable>(
        queue: DispatchQueue? = nil,
        mapError: @escaping (Error, Data?) -> ExposureError,
        completionHandler: @escaping (DataResponse<Object>) -> Void)
        -> Self
    {
        let responseSerializer = DataResponseSerializer<Object> { request, response, data, error in
            guard error == nil, let jsonData = data else {
                return .failure(mapError(error!, data))
            }

            do {
                let object = try JSONDecoder().decode(Object.self, from: jsonData)
                return .success(object)
            }
            catch let decodingError as DecodingError {
                switch decodingError {
                case .dataCorrupted(let context): return .failure(ExposureError.serialization(reason: .objectSerialization(reason: context.debugDescription, json: jsonData)))
                case .keyNotFound(_, let context): return .failure(ExposureError.serialization(reason: .objectSerialization(reason: context.debugDescription, json: jsonData)))
                case .typeMismatch(_, let context): return .failure(ExposureError.serialization(reason: .objectSerialization(reason: context.debugDescription, json: jsonData)))
                case .valueNotFound(_, let context): return .failure(ExposureError.serialization(reason: .objectSerialization(reason: context.debugDescription, json: jsonData)))
                }
            }
            catch (let e) {
                return .failure(ExposureError.serialization(reason: .objectSerialization(reason: "Unable to serialize object: \(e.localizedDescription)", json: jsonData)))
            }
        }

        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    /// Extends `DataRequest` to enable *Exposure* specific parsing.
    ///
    /// - parameter queue: The queue on which the completion handler is dispatched.
    /// - parameter mapError: The error mapping function to convert between *untyped* `Error` and `ExposureError`.
    /// - parameter completionHandler: The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func emptyExposureResponse(
        queue: DispatchQueue? = nil,
        mapError: @escaping (Error, Data?) -> ExposureError,
        completionHandler: @escaping (DataResponse<Data>) -> Void)
        -> Self
    {
        let responseSerializer = DataResponseSerializer<Data> { request, response, data, error in
            guard error == nil, let jsonData = data else {
                return .failure(mapError(error!, data))
            }
            return .success(jsonData)
        }
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
}
