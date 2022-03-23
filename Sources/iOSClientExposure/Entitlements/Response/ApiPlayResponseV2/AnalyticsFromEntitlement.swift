//
//  Analytics.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2021-04-19.
//  Copyright © 2021 emp. All rights reserved.
//

import Foundation

/// Analytics info in the entitlement/play request
public struct AnalyticsFromEntitlement: Codable {
    public let bucket: Int?
    public let postInterval: Int?
    public let tag: String?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bucket = try container.decodeIfPresent(Int.self, forKey: .bucket)
        postInterval = try container.decodeIfPresent(Int.self, forKey: .postInterval)
        tag = try container.decodeIfPresent(String.self, forKey: .tag)
        
    }
    
    internal enum CodingKeys: String, CodingKey {
        case bucket
        case postInterval
        case tag
    }
}
