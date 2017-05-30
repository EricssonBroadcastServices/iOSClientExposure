//
//  Season.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Season {
    public let created: String?
    public let changed: String?
    public let season: String?
    
    public let tags: [Tag]?
    public let localized: [LocalizedData]?
    
    public let tvShowId: String?
    public let seasonId: String?
    public let episodeCount: Int?
    
    public let episodes: [Asset]?
    
    public let publishedDate: String?
    public let availableDate: String?
    public let startYear: Int?
    public let endYear: Int?
    
    public let linkedEntities: [LinkedEntity]?
    public let externalReferences: [ExternalReference]?
    public let customData: [String: Any]?
    
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        created = actualJson[JSONKeys.created.rawValue].string
        changed = actualJson[JSONKeys.changed.rawValue].string
        season = actualJson[JSONKeys.season.rawValue].string
        
        tags = actualJson[JSONKeys.tags.rawValue].arrayObject?.flatMap{ Tag(json: $0) }
        localized = actualJson[JSONKeys.localized.rawValue].arrayObject?.flatMap{ LocalizedData(json: $0) }
        
        tvShowId = actualJson[JSONKeys.tvShowId.rawValue].string
        seasonId = actualJson[JSONKeys.seasonId.rawValue].string
        episodeCount = actualJson[JSONKeys.episodeCount.rawValue].int
        
        episodes = actualJson[JSONKeys.episodes.rawValue].arrayObject?.flatMap{ Asset(json: $0) }
        
        publishedDate = actualJson[JSONKeys.publishedDate.rawValue].string
        availableDate = actualJson[JSONKeys.availableDate.rawValue].string
        startYear = actualJson[JSONKeys.startYear.rawValue].int
        endYear = actualJson[JSONKeys.endYear.rawValue].int
        
        linkedEntities = actualJson[JSONKeys.linkedEntities.rawValue].arrayObject?.flatMap{ LinkedEntity(json: $0) }
        externalReferences = actualJson[JSONKeys.externalReferences.rawValue].arrayObject?.flatMap{ ExternalReference(json: $0) }
        customData = actualJson[JSONKeys.customData.rawValue].dictionaryObject
        
        if created == nil && changed == nil && season == nil && tags == nil && localized == nil && tvShowId == nil && seasonId == nil
            && episodeCount == nil && episodes == nil && publishedDate == nil && availableDate == nil && startYear == nil
            && endYear == nil && linkedEntities == nil && externalReferences == nil && customData == nil { return nil }
    }
    
    internal enum JSONKeys: String {
        case created = "created"
        case changed = "changed"
        case season = "season"
        case tags = "tags"
        case localized = "localized"
        case tvShowId = "tvShowId"
        case seasonId = "seasonId"
        case episodeCount = "episodeCount"
        case episodes = "episodes"
        case publishedDate = "publishedDate"
        case availableDate = "availableDate"
        case startYear = "startYear"
        case endYear = "endYear"
        case linkedEntities = "linkedEntities"
        case externalReferences = "externalReferences"
        case customData = "customData"
    }
}
