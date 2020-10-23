//
//  AllDownloads.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-10-20.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

public struct AllDownloads: Codable {
    public let accountId: String?
    public let assets: [DownloadedAssets]?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accountId = try container.decodeIfPresent(String.self, forKey: .accountId)
        assets = try container.decodeIfPresent([DownloadedAssets].self, forKey: .assets)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case accountId
        case assets

    }
}


public struct DownloadedAssets: Codable {
    public let assetId : String?
    public let downloadCount : Int?
    public let downloads: [Downloads]?
    public let changed : String?
    
 
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        assetId = try container.decodeIfPresent(String.self, forKey: .assetId)
        downloadCount = try container.decodeIfPresent(Int.self, forKey: .downloadCount)
        downloads = try container.decodeIfPresent([Downloads].self, forKey: .downloads)
        changed = try container.decodeIfPresent(String.self, forKey: .changed)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case assetId
        case downloadCount
        case downloads
        case changed

    }
}
