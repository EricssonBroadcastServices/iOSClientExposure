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
    public let language: String
    public let defaultLanguage: String?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        defaultLanguage = try container.decode(String.self, forKey: .defaultLanguage)
        
        //If language not present set to defaultLanguage or "en" for defaultLanguage
        let tempLanguage = try container.decodeIfPresent(String.self, forKey: .language)
        let tempDefaultLanguage = defaultLanguage ?? "en"
        
        language = tempLanguage ?? tempDefaultLanguage
    }

    internal enum CodingKeys: String, CodingKey {
        case displayName
        case language
        case defaultLanguage
    }
}

