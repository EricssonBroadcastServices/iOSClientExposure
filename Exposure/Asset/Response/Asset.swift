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

// MARK: - ExposureConvertible
extension Asset: ExposureConvertible {
    public init?(json: Any) {
        let actualJson = JSON(json)
        created = actualJson[JSONKeys.created.rawValue].string
        changed = actualJson[JSONKeys.changed.rawValue].string
        assetId = actualJson[JSONKeys.assetId.rawValue].string
        type = AssetType(string: actualJson[JSONKeys.type.rawValue].string)
        
        localized = actualJson[JSONKeys.localized.rawValue].arrayObject?.flatMap{ LocalizedData(json: $0) }
        tags = actualJson[JSONKeys.tags.rawValue].arrayObject?.flatMap{ Tag(json: $0) }
        publications = actualJson[JSONKeys.publications.rawValue].arrayObject?.flatMap{ Publication(json: $0) }
        
        episode = actualJson[JSONKeys.episode.rawValue].string
        season = actualJson[JSONKeys.season.rawValue].string
        seasonId = actualJson[JSONKeys.seasonId.rawValue].string
        seasons = actualJson[JSONKeys.seasons.rawValue].arrayObject?.flatMap{ Season(json: $0) }
        participants = actualJson[JSONKeys.participants.rawValue].arrayObject?.flatMap{ Person(json: $0) }
        productionYear = actualJson[JSONKeys.productionYear.rawValue].int
        popularityScores = actualJson[JSONKeys.popularityScores.rawValue].dictionaryObject
        releaseDate = actualJson[JSONKeys.releaseDate.rawValue].string
        originalTitle = actualJson[JSONKeys.originalTitle.rawValue].string
        
        live = actualJson[JSONKeys.live.rawValue].bool
        productionCountries = actualJson[JSONKeys.productionCountries.rawValue].array?.flatMap{ $0.string }
        subtitles = actualJson[JSONKeys.subtitles.rawValue].array?.flatMap{ $0.string }
        audioTracks = actualJson[JSONKeys.audioTracks.rawValue].array?.flatMap{ $0.string }
        spokenLanguages = actualJson[JSONKeys.spokenLanguages.rawValue].array?.flatMap{ $0.string }
        medias = actualJson[JSONKeys.medias.rawValue].arrayObject?.flatMap{ Media(json: $0) }
        parentalRatings = actualJson[JSONKeys.parentalRatings.rawValue].arrayObject?.flatMap{ ParentalRating(json: $0) }
        
        linkedEntities = actualJson[JSONKeys.linkedEntities.rawValue].arrayObject?.flatMap{ LinkedEntity(json: $0) }
        runtime = actualJson[JSONKeys.runtime.rawValue].int
        tvShowId = actualJson[JSONKeys.tvShowId.rawValue].string
        expires = actualJson[JSONKeys.expires.rawValue].string
        customData = actualJson[JSONKeys.customData.rawValue].dictionaryObject
        externalReferences = actualJson[JSONKeys.externalReferences.rawValue].arrayObject?.flatMap{ ExternalReference(json: $0) }
        rating = actualJson[JSONKeys.rating.rawValue].float
        
        markers = actualJson[JSONKeys.markers.rawValue].arrayObject?.flatMap{ Marker(json: $0) }
        lastViewedTime = actualJson[JSONKeys.lastViewedTime.rawValue].int
        lastViewedOffset = actualJson[JSONKeys.lastViewedOffset.rawValue].int
        
        if (created == nil && changed == nil && assetId == nil && type == nil && localized == nil && tags == nil && publications == nil)
        && (episode == nil && season == nil && seasonId == nil && seasons == nil && participants == nil && productionYear == nil)
        && (popularityScores == nil && releaseDate == nil && originalTitle == nil && live == nil && productionCountries == nil && subtitles == nil)
        && (audioTracks == nil && spokenLanguages == nil && medias == nil && parentalRatings == nil && linkedEntities == nil && runtime == nil)
        && (tvShowId == nil && expires == nil && customData == nil && externalReferences == nil && rating == nil)
        && (markers == nil && lastViewedOffset == nil && lastViewedTime == nil){
            return nil
        }
    }
    
    internal enum JSONKeys: String {
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
            default: return "OTHER"
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
