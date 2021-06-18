//
//  Ads.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-11-11.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

/// Ads in the entitlement/play request 
public struct Ads: Codable {
    public let stitcher: String?
    public let stitcherProfileId: String?
    public let insertionDuration: Int?
    public let insertionMaxCount: Int?
    public let clips: [AdClips]?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stitcher = try container.decodeIfPresent(String.self, forKey: .stitcher)
        stitcherProfileId = try container.decodeIfPresent(String.self, forKey: .stitcherProfileId)
        insertionDuration = try container.decodeIfPresent(Int.self, forKey: .insertionDuration)
        insertionMaxCount = try container.decodeIfPresent(Int.self, forKey: .insertionMaxCount)
        clips = try container.decodeIfPresent([AdClips].self, forKey: .clips)
        
    }
    
    internal enum CodingKeys: String, CodingKey {
        case stitcher
        case stitcherProfileId
        case insertionDuration
        case insertionMaxCount
        case clips
    }
}





