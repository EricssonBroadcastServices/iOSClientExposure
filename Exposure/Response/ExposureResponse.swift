//
//  ExposureResponse.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

// Response struct wrapping the *Exposure* request, response and result.
public struct ExposureResponse<Value: Decodable> {
    /// Internal data structure
    internal let dataResponse: DataResponse<Value>
    
    /// The URL request sent to the server.
    public var request: URLRequest? {
        return dataResponse.request
    }
    
    /// The server's response to the URL request.
    public var response: HTTPURLResponse? {
        return dataResponse.response
    }
    
    /// The data returned by the server.
    public var data: Data? {
        return dataResponse.data
    }
    
    /// Returns the associated value of the result if it is a success, `nil` otherwise.
    public var value: Value? {
        return dataResponse.value
    }
    
    /// Returns the associated `ExposureError` value if the result if it is a failure, `nil` otherwise.
    public var error: ExposureError? {
        if let exposureError = dataResponse.error as? ExposureError {
            return exposureError
        }
        else if let generalError = dataResponse.error {
            return ExposureError.generalError(error: generalError)
        }
        else {
            return nil
        }
    }
}
