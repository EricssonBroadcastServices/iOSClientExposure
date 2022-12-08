//
//  Downloadinfo.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-05-08.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation


public struct DownloadInfo: Codable {
    public let assetId: String
    public let accountId: String
    public let productId: String
    public let publicationId: String
    public let durationInMs: Int
    public let audios: [Audios]?
    public let videos: [Videos]
    public let subtitles: [Subtitles]?
    public let downloadCount: Int?
    public let maxDownloadCount: Int?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        assetId = try container.decode(String.self, forKey: .assetId)
        accountId = try container.decode(String.self, forKey: .accountId)
        productId = try container.decode(String.self, forKey: .productId)
        publicationId = try container.decode(String.self, forKey: .publicationId)
        durationInMs = try container.decode(Int.self, forKey: .durationInMs)
        audios = try container.decodeIfPresent([Audios].self, forKey: .audios)
        videos = try container.decode([Videos].self, forKey: .videos)
        subtitles = try container.decodeIfPresent([Subtitles].self, forKey: .subtitles)
        downloadCount = try container.decodeIfPresent(Int.self, forKey: .downloadCount)
        maxDownloadCount = try container.decodeIfPresent(Int.self, forKey: .maxDownloadCount)
        
    }
    
    internal enum CodingKeys: String, CodingKey {
        case assetId
        case accountId
        case productId
        case publicationId
        case durationInMs
        case audios
        case videos
        case subtitles
        case downloadCount
        case maxDownloadCount
    }
}


public struct Audios: Codable {
    public let name: String?
    public let bitrate: Int?
    public let language: String?
    public let fileSize: Int?
    public let hlsName: String?
}
 
public struct Videos: Codable {
    public let name: String?
    public let bitrate: Int?
    public let fileSize: Int?
    public let language: String?
    public let width: Int?
    public let height: Int?
    public let hlsName: String?
}


public struct Subtitles: Codable {
    public let name: String?
    public let language: String?
    public let fileSize: Int?
    public let hlsName: String?
    
}
