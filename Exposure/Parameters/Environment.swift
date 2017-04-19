//
//  Environment.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Environment {
    public let baseUrl: String
    public let customer: String
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
