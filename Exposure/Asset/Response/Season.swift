//
//  Season.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Season: Codable {
    /// When this `Season` was created
    public let created: String?
    
    /// Last known change made to the entry
    public let changed: String?
    
    /// Season
    public let season: String?
    
    /// Associated `Tag`s
    public let tags: [Tag]?
    
    /// Localization and internationalization
    public var localized: [LocalizedData]?
    
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
    public let customData: [String: AnyJSONType]?

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(changed, forKey: .changed)
        try container.encodeIfPresent(season, forKey: .season)
        try container.encodeIfPresent(tags, forKey: .tags)
        
        try container.encodeIfPresent(localized, forKey: .localized)
        try container.encodeIfPresent(tvShowId, forKey: .tvShowId)
        try container.encodeIfPresent(seasonId, forKey: .seasonId)
        try container.encodeIfPresent(episodeCount, forKey: .episodeCount)
        
        try container.encodeIfPresent(episodes, forKey: .episodes)
        try container.encodeIfPresent(publishedDate, forKey: .publishedDate)
        try container.encodeIfPresent(availableDate, forKey: .availableDate)
        try container.encodeIfPresent(startYear, forKey: .startYear)
        
        try container.encodeIfPresent(endYear, forKey: .endYear)
        try container.encodeIfPresent(linkedEntities, forKey: .linkedEntities)
        try container.encodeIfPresent(externalReferences, forKey: .externalReferences)
        try container.encodeIfPresent(customData, forKey: .customData)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        created = try container.decodeIfPresent(String.self, forKey: .created)
        changed = try container.decodeIfPresent(String.self, forKey: .changed)
        season = try container.decodeIfPresent(String.self, forKey: .season)
        tags = try container.decodeIfPresent([Tag].self, forKey: .tags)
        
        localized = try container.decodeIfPresent([LocalizedData].self, forKey: .localized)
        tvShowId = try container.decodeIfPresent(String.self, forKey: .tvShowId)
        seasonId = try container.decodeIfPresent(String.self, forKey: .seasonId)
        episodeCount = try container.decodeIfPresent(Int.self, forKey: .episodeCount)
        
        episodes = try container.decodeIfPresent([Asset].self, forKey: .episodes)
        publishedDate = try container.decodeIfPresent(String.self, forKey: .publishedDate)
        availableDate = try container.decodeIfPresent(String.self, forKey: .availableDate)
        startYear = try container.decodeIfPresent(Int.self, forKey: .startYear)
        
        endYear = try container.decodeIfPresent(Int.self, forKey: .endYear)
        linkedEntities = try container.decodeIfPresent([LinkedEntity].self, forKey: .linkedEntities)
        externalReferences = try container.decodeIfPresent([ExternalReference].self, forKey: .externalReferences)
        customData = try container.decodeIfPresent([String: AnyJSONType].self, forKey: .customData)
    }

    internal enum CodingKeys: String, CodingKey {
        case created, changed, season, tags, localized, tvShowId, seasonId, episodeCount, episodes
        case publishedDate, availableDate, startYear, endYear, linkedEntities, externalReferences, customData
    }
}
