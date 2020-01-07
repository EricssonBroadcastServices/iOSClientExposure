//
//  UserDetails.swift
//  Exposure-iOS
//
//  Created by Udaya Sri Senarathne on 2020-01-07.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

/// `UserDetails` contains *user's details* related to the language preferences user has.
public struct UserDetails : Decodable {
    public let displayName: String?
    public let language: String?
    public let defaultLanguage: String?
}

