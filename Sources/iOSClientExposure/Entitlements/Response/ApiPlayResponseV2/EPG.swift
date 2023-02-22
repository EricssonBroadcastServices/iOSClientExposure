//
//  EPG.swift
//  
//
//  Created by Udaya Sri Senarathne on 2023-02-10.
//

import Foundation

public struct EPG: Codable {
    
    public let enabled: Bool?
    public let entitlementCheck: Bool?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled)
        entitlementCheck = try container.decodeIfPresent(Bool.self, forKey: .entitlementCheck)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case enabled
        case entitlementCheck
    }
}
