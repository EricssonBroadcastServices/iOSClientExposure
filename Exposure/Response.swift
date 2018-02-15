//
//  Response.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-02-15.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

/// Used to store all data associated with a serialized response of a data or upload request.
public struct Response<Value> {
    /// The URL request sent to the server.
    public let request: URLRequest?
    
    /// The server's response to the URL request.
    public let response: HTTPURLResponse?
    
    /// The data returned by the server.
    public let data: Data?
    
    public let result: Request.Result<Value>
    
    /// Returns the associated value of the result if it is a success, `nil` otherwise.
    public var value: Value?
    
    /// Returns the associated error value if the result if it is a failure, `nil` otherwise.
    public var error: Error?
    
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        result: Request.Result<Value>)
    {
        self.request = request
        self.response = response
        self.data = data
        self.result = result
    }
}
