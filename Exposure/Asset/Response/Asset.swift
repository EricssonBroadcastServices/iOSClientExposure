//
//  Asset.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Asset {
    /// Date when this asset was created, in UTC format.
    public let created: String?
    
    /// Date when this asset was last changed, in UTC format.
    public let changed: String?
    
    /// Identifier for the asset
    public let assetId: String
    
    /// Asset type
    public var type: String?
    
    /// Localization data
    public var localized: [LocalizedData]?
    
    /// Associated tags
    public let tags: [Tag]?
    
    /// Publications
    public let publications: [Publication]?
    
    
    public let episode: String?
    public let season: String?
    public let seasonId: String?
    
    /// Seasons related to this asset.
    public let seasons: [Season]?
    
    /// People associated with this asset
    public let participants: [Person]?
    
    /// Year produced
    public let productionYear: Int?
    public let popularityScores: [String: AnyJSONType]?
    
    /// Date when this asset was released, in UTC format.
    public let releaseDate: String?
    
    /// Original title
    public let originalTitle: String?
    
    /// If this asset is a live asset
    public let live: Bool?
    public let productionCountries: [String]?
    
    /// Subtitles available for the asset
    public let subtitles: [String]?
    
    /// Audio tracks available for the asset
    public let audioTracks: [String]?
    
    /// Spoken languages during playback
    public let spokenLanguages: [String]?
    
    /// Different media formats available
    public let medias: [Media]?
    
    /// Parental ratings
    public let parentalRatings: [ParentalRating]?
    
    
    public let linkedEntities: [LinkedEntity]?
    
    /// The duration of the asset in seconds.
    public let runtime: Int?
    public let tvShowId: String?
    public let expires: String?
    public let customData: [String: AnyJSONType]?
    public let externalReferences: [ExternalReference]?
    public let rating: Float?
    
    public let markers: [Marker]?
    
    /// User specific data regarding this asset
    public let userData: AssetUserData?
    
    /// Duration in milliseconds
    public var duration: Int64?
}

extension Asset: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(changed, forKey: .changed)
        try container.encode(assetId, forKey: .assetId)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(localized, forKey: .localized)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(publications, forKey: .publications)
        
        try container.encodeIfPresent(episode, forKey: .episode)
        try container.encodeIfPresent(season, forKey: .season)
        try container.encodeIfPresent(seasonId, forKey: .seasonId)
        
        try container.encodeIfPresent(seasons, forKey: .seasons)
        
        try container.encodeIfPresent(participants, forKey: .participants)
        
        try container.encodeIfPresent(productionYear, forKey: .productionYear)
        try container.encodeIfPresent(productionCountries, forKey: .productionCountries)
        
        try container.encodeIfPresent(popularityScores, forKey: .popularityScores)
        
        try container.encodeIfPresent(releaseDate, forKey: .releaseDate)
        try container.encodeIfPresent(originalTitle, forKey: .originalTitle)
        try container.encodeIfPresent(live, forKey: .live)
        
        try container.encodeIfPresent(subtitles, forKey: .subtitles)
        try container.encodeIfPresent(audioTracks, forKey: .audioTracks)
        try container.encodeIfPresent(spokenLanguages, forKey: .spokenLanguages)
        try container.encodeIfPresent(medias, forKey: .medias)
        
        try container.encodeIfPresent(parentalRatings, forKey: .parentalRatings)
        try container.encodeIfPresent(linkedEntities, forKey: .linkedEntities)
        try container.encodeIfPresent(runtime, forKey: .runtime)
        try container.encodeIfPresent(tvShowId, forKey: .tvShowId)
        
        try container.encodeIfPresent(expires, forKey: .expires)
        try container.encodeIfPresent(customData, forKey: .customData)
        try container.encodeIfPresent(externalReferences, forKey: .externalReferences)
        try container.encodeIfPresent(rating, forKey: .rating)
        try container.encodeIfPresent(markers, forKey: .markers)
        try container.encodeIfPresent(userData, forKey: .userData)
        try container.encodeIfPresent(duration, forKey: .duration)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        created = try container.decodeIfPresent(String.self, forKey: .created)
        changed = try container.decodeIfPresent(String.self, forKey: .changed)
        assetId = try container.decode(String.self, forKey: .assetId)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        localized = try container.decodeIfPresent([LocalizedData].self, forKey: .localized)
        tags = try container.decodeIfPresent([Tag].self, forKey: .tags)
        publications = try container.decodeIfPresent([Publication].self, forKey: .publications)

        episode = try container.decodeIfPresent(String.self, forKey: .episode)
        season = try container.decodeIfPresent(String.self, forKey: .season)
        seasonId = try container.decodeIfPresent(String.self, forKey: .seasonId)

        seasons = try container.decodeIfPresent([Season].self, forKey: .seasons)

        participants = try container.decodeIfPresent([Person].self, forKey: .participants)

        productionYear = try container.decodeIfPresent(Int.self, forKey: .productionYear)
        productionCountries = try container.decodeIfPresent([String].self, forKey: .productionCountries)

        popularityScores = try container.decodeIfPresent([String: AnyJSONType].self, forKey: .popularityScores)

        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        live = try container.decodeIfPresent(Bool.self, forKey: .live)

        subtitles = try container.decodeIfPresent([String].self, forKey: .subtitles)
        audioTracks = try container.decodeIfPresent([String].self, forKey: .audioTracks)
        spokenLanguages = try container.decodeIfPresent([String].self, forKey: .spokenLanguages)
        medias = try container.decodeIfPresent([Media].self, forKey: .medias)
        
        parentalRatings = try container.decodeIfPresent([ParentalRating].self, forKey: .parentalRatings)
        linkedEntities = try container.decodeIfPresent([LinkedEntity].self, forKey: .linkedEntities)
        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        tvShowId = try container.decodeIfPresent(String.self, forKey: .tvShowId)
        
        expires = try container.decodeIfPresent(String.self, forKey: .expires)
        customData = try container.decodeIfPresent([String: AnyJSONType].self, forKey: .customData)
        externalReferences = try container.decodeIfPresent([ExternalReference].self, forKey: .externalReferences)
        rating = try container.decodeIfPresent(Float.self, forKey: .rating)
        markers = try container.decodeIfPresent([Marker].self, forKey: .markers)
        userData = try container.decodeIfPresent(AssetUserData.self, forKey: .userData)
        duration = try container.decodeIfPresent(Int64.self, forKey: .duration)
    }

    internal enum CodingKeys: String, CodingKey {
        case created
        case changed
        case assetId
        case type
        case localized
        case tags
        case publications
        case episode
        case season
        case seasonId
        case seasons
        case participants
        case productionYear
        case popularityScores
        case releaseDate
        case originalTitle
        case live
        case productionCountries
        case subtitles
        case audioTracks
        case spokenLanguages
        case medias
        case parentalRatings
        case linkedEntities
        case runtime
        case tvShowId
        case expires
        case customData
        case externalReferences
        case rating
        case markers
        case userData
        case duration
    }
}
