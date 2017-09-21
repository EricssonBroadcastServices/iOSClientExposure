//
//  Season.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Season: Decodable {
    /// When this `Season` was created
    public let created: String?
    
    /// Last known change made to the entry
    public let changed: String?
    
    /// Season
    public let season: String?
    
    /// Associated `Tag`s
    public let tags: [Tag]?
    
    /// Localization and internationalization
    public let localized: [LocalizedData]?
    
    public let tvShowId: String?
    public let seasonId: String?
    
    /// Number of eposides available in this season
    public let episodeCount: Int?
    
    /// Episodes for this season
    public let episodes: [Asset]?
    
    /// Date when the season was published, in UTC format
    public let publishedDate: String?
    
    /// Date when the season was made available, in UTC format
    public let availableDate: String?
    
    /// Year when the season premiered
    public let startYear: Int?
    
    /// Year when the season ended
    public let endYear: Int?
    
    public let linkedEntities: [LinkedEntity]?
    public let externalReferences: [ExternalReference]?
    
    /// Any custom data in `json` format
    public let customData: [String: Any]?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        created = try? container.decode(String.self, forKey: .created)
        changed = try? container.decode(String.self, forKey: .changed)
        season = try? container.decode(String.self, forKey: .season)
        tags = try? container.decode([Tag].self, forKey: .tags)
        localized = try? container.decode([LocalizedData].self, forKey: .localized)
        tvShowId = try? container.decode(String.self, forKey: .tvShowId)
        seasonId = try? container.decode(String.self, forKey: .seasonId)
        episodeCount = try? container.decode(Int.self, forKey: .episodeCount)
        episodes = try? container.decode([Asset].self, forKey: .episodes)
        publishedDate = try? container.decode(String.self, forKey: .publishedDate)
        availableDate = try? container.decode(String.self, forKey: .availableDate)
        startYear = try? container.decode(Int.self, forKey: .startYear)
        endYear = try? container.decode(Int.self, forKey: .endYear)
        linkedEntities = try? container.decode([LinkedEntity].self, forKey: .linkedEntities)
        externalReferences = try? container.decode([ExternalReference].self, forKey: .externalReferences)
        customData = try? container.decode([String: Any].self, forKey: .customData)
    }

    internal enum CodingKeys: String, CodingKey {
        case created, changed, season, tags, localized, tvShowId, seasonId, episodeCount, episodes
        case publishedDate, availableDate, startYear, endYear, linkedEntities, externalReferences, customData
    }
}
