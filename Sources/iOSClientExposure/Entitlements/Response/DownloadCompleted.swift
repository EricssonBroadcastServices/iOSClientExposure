//
//  DownloadCompleted.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-10-16.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

public struct DownloadCompleted: Codable {
    public let assetId: String
    public let downloadCount: Int?
    public let downloads: [Downloads]?
    public let changed: String?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        assetId = try container.decode(String.self, forKey: .assetId)
        downloadCount = try container.decodeIfPresent(Int.self, forKey: .downloadCount)
        downloads = try container.decodeIfPresent([Downloads].self, forKey: .downloads)
        changed = try container.decodeIfPresent(String.self, forKey: .changed)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(assetId, forKey: .assetId)
        try container.encodeIfPresent(downloadCount, forKey: .downloadCount)
        try container.encodeIfPresent(downloads, forKey: .downloads)
        try container.encodeIfPresent(changed, forKey: .changed)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case assetId
        case downloadCount
        case downloads
        case changed
    }
}
