//
//  Environment.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Customer specific *Exposure* environment.
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

extension Environment: Equatable {
    public static func == (lhs: Environment, rhs: Environment) -> Bool {
        return lhs.baseUrl == rhs.baseUrl && lhs.customer == rhs.customer && lhs.businessUnit == rhs.businessUnit
    }
}
