//
//  Environment.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Environment {
    /// Base exposure url. This is the customer specific URL to Exposure
    public let baseUrl: String
    
    /// EMP Customer Group identifier
    public let customer: String
    
    /// EMP Business Unit identifier
    public let businessUnit: String
    
    public init(baseUrl: String, customer: String, businessUnit: String) {
        self.baseUrl = baseUrl
        self.customer = customer
        self.businessUnit = businessUnit
    }
    
    public var basePath: String {
        return "/v1/customer/" + customer + "/businessunit/" + businessUnit
    }
    
    public var apiUrl: String {
        return baseUrl + basePath
    }
}
