//
//  Asset.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Asset {
    /// Date when this asset was created, in UTC format.
    public let created: String?
    
    /// Date when this asset was last changed, in UTC format.
    public let changed: String?
    
    /// Identifier for the asset
    public let assetId: String?
    
    /// Asset type
    public let type: AssetType?
    
    /// Localization data
    public let localized: [LocalizedData]?
    
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
    public let popularityScores: [String: Any]?
    
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
    public let customData: [String: Any]?
    public let externalReferences: [ExternalReference]?
    public let rating: Float?
    
    public let markers: [Marker]?
    
    /// When this asset was last viewed.
    public let lastViewedTime: Int?
    
    /// Offset from where last playback ended. Used by *Session Shift* to enable bookmarking functionality.
    public let lastViewedOffset: Int?
}

extension Asset: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        created = try container.decode(String?.self, forKey: .created)
        changed = try container.decode(String?.self, forKey: .changed)
        assetId = try container.decode(String?.self, forKey: .assetId)
        type = try container.decode(AssetType?.self, forKey: .type)
        localized = try container.decode([LocalizedData]?.self, forKey: .localized)
        tags = try container.decode([Tag]?.self, forKey: .tags)
        publications = try container.decode([Publication]?.self, forKey: .publications)

        episode = try container.decode(String?.self, forKey: .episode)
        season = try container.decode(String?.self, forKey: .season)
        seasonId = try container.decode(String?.self, forKey: .seasonId)

        seasons = try container.decode([Season]?.self, forKey: .seasons)

        participants = try container.decode([Person]?.self, forKey: .participants)

        productionYear = try container.decode(Int?.self, forKey: .productionYear)
        productionCountries = try container.decode([String]?.self, forKey: .productionCountries)

        popularityScores = try container.decode([String: Any]?.self, forKey: .popularityScores)

        releaseDate = try container.decode(String?.self, forKey: .releaseDate)
        originalTitle = try container.decode(String?.self, forKey: .originalTitle)
        live = try container.decode(Bool?.self, forKey: .live)

        subtitles = try container.decode([String]?.self, forKey: .subtitles)
        audioTracks = try container.decode([String]?.self, forKey: .audioTracks)
        spokenLanguages = try container.decode([String]?.self, forKey: .spokenLanguages)
        medias = try container.decode([Media]?.self, forKey: .medias)
        parentalRatings = try container.decode([ParentalRating]?.self, forKey: .parentalRatings)
        linkedEntities = try container.decode([LinkedEntity]?.self, forKey: .linkedEntities)
        runtime = try container.decode(Int?.self, forKey: .runtime)
        tvShowId = try container.decode(String?.self, forKey: .tvShowId)
        expires = try container.decode(String?.self, forKey: .expires)
        customData = try container.decode([String: Any]?.self, forKey: .customData)
        externalReferences = try container.decode([ExternalReference]?.self, forKey: .externalReferences)
        rating = try container.decode(Float?.self, forKey: .rating)
        markers = try container.decode([Marker]?.self, forKey: .markers)
        lastViewedTime = try container.decode(Int?.self, forKey: .lastViewedTime)
        lastViewedOffset = try container.decode(Int?.self, forKey: .lastViewedOffset)
    }

    internal enum CodingKeys: String, CodingKey {
        case created = "created"
        case changed = "changed"
        case assetId = "assetId"
        case type = "type"
        case localized = "localized"
        case tags = "tags"
        case publications = "publications"
        case episode = "episode"
        case season = "season"
        case seasonId = "seasonId"
        case seasons = "seasons"
        case participants = "participants"
        case productionYear = "productionYear"
        case popularityScores = "popularityScores"
        case releaseDate = "releaseDate"
        case originalTitle = "originalTitle"
        case live = "live"
        case productionCountries = "productionCountries"
        case subtitles = "subtitles"
        case audioTracks = "audioTracks"
        case spokenLanguages = "spokenLanguages"
        case medias = "medias"
        case parentalRatings = "parentalRatings"
        case linkedEntities = "linkedEntities"
        case runtime = "runtime" // The duration of the asset in seconds.,
        case tvShowId = "tvShowId"
        case expires = "expires"
        case customData = "customData"
        case externalReferences = "externalReferences"
        case rating = "rating"
        case markers = "markers"
        case lastViewedTime = "lastViewedTime"
        case lastViewedOffset = "lastViewedOffset"
    }
}

extension Asset {
    public enum AssetType: Equatable, Hashable {
        case movie
        case tvShow
        case episode
        case clip
        case tvChannel
        case ad
        case liveEvent
        case other(type: String)
        
        internal init?(string: String?) {
            guard let value = string else { return nil }
            self = AssetType(string: value)
        }
        
        internal init(string: String) {
            switch string {
            case "MOVIE": self = .movie
            case "TV_SHOW": self = .tvShow
            case "EPISODE": self = .episode
            case "CLIP": self = .clip
            case "TV_CHANNEL": self = .tvChannel
            case "AD": self = .ad
            case "LIVE_EVENT": self = .liveEvent
            case "OTHER": self = .other(type: string)
            default: self = .other(type: string)
            }
        }
        
        internal var queryParam: String {
            switch self {
            case .movie: return "MOVIE"
            case .tvShow: return "TV_SHOW"
            case .episode: return "EPISODE"
            case .clip: return "CLIP"
            case .tvChannel: return "TV_CHANNEL"
            case .ad: return "AD"
            case .liveEvent: return "LIVE_EVENT"
            case .other(type: _): return "OTHER"
            }
        }
        
        public static func == (lhs: AssetType, rhs: AssetType) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        
        public var hashValue: Int {
            switch self {
            case .other(type: let value): return (queryParam+"_"+value).hashValue
            default: return queryParam.hashValue
            }
        }
    }
}
