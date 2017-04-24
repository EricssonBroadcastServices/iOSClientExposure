//
//  SessionToken.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-22.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct SessionToken {
    public let value: String
    
    
    public var authorizationHeader: [String: String] {
        return ["Authorization": "Bearer " + value]
    }
    
    public init(value: String) {
        self.value = value
    }
    
    public init?(value: String?) {
        guard let val = value else {
            return nil
        }
        self.value = val
    }
}
