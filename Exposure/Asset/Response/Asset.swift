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
    public let assetId: String?
    
    /// Asset type
    public var type: AssetType?
    
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
}

extension Asset: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        created = try container.decodeIfPresent(String.self, forKey: .created)
        changed = try container.decodeIfPresent(String.self, forKey: .changed)
        assetId = try container.decodeIfPresent(String.self, forKey: .assetId)
        type = AssetType(string: try container.decodeIfPresent(String.self, forKey: .type))
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
