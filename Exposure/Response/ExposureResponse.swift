//
//  ExposureResponse.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

public struct ExposureResponse<Value: ExposureConvertible> {
    internal let dataResponse: DataResponse<Value>
    
    public var request: URLRequest? {
        return dataResponse.request
    }
    
    public var response: HTTPURLResponse? {
        return dataResponse.response
    }
    
    public var data: Data? {
        return dataResponse.data
    }
    
    public var value: Value? {
        return dataResponse.value
    }
    
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
