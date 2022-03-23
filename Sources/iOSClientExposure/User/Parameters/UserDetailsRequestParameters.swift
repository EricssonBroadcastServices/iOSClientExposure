//
//  UserDetailsRequest.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-01-07.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

/// Defines an *Exposure User Details request* parameters / http body.
public struct UserDetailsRequestParameters:Encodable{
    
    public var displayName: String
    public var language: String
    
    public init(displayName: String, language: String) {
        self.displayName = displayName
        self.language = language
    }
}
