//
//  CDN.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2021-04-19.
//  Copyright © 2021 emp. All rights reserved.
//

import Foundation

/// CDN info in the entitlement/play request
public struct CDNInfoFromEntitlement: Codable {
    public let profile: String?
    public let host: String?
    public let provider: String?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        profile = try container.decodeIfPresent(String.self, forKey: .profile)
        host = try container.decodeIfPresent(String.self, forKey: .host)
        provider = try container.decodeIfPresent(String.self, forKey: .provider)
        
    }
    
    internal enum CodingKeys: String, CodingKey {
        case profile
        case host
        case provider
    }
}
