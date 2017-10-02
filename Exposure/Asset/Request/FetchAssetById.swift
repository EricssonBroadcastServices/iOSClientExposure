//
//  FetchAssetById.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

public struct FetchAssetById: Exposure, FilteredFields, FilteredPublish {
    public typealias Response = Asset
    
    public var endpointUrl: String {
        return environment.apiUrl + "/content/asset/" + assetId
    }
    
    public var parameters: [String: Any] {
        return queryParams
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    internal var query: Query
    public var publishFilter: PublishFilter
    public var fieldsFilter: FieldsFilter
    
    public let environment: Environment
    public let assetId: String
    
    public init(environment: Environment, assetId: String) {
        self.environment = environment
        self.assetId = assetId
        self.fieldsFilter = FieldsFilter()
        self.publishFilter = PublishFilter()
        self.query = Query()
    }
    
    internal enum Keys: String {
        case onlyPublished = "onlyPublished"
        case fieldSet = "fieldSet"
        case excludeFields = "excludeFields"
        case includeFields = "includeFields"
        case seasonsIncluded = "includeSeasons"
        case episodesIncluded = "includeEpisodes"
    }
    
    internal var queryParams: [String: Any] {
        var params:[String: Any] = [
            Keys.onlyPublished.rawValue: publishFilter.onlyPublished,
            Keys.fieldSet.rawValue: fieldsFilter.fieldSet.rawValue,
        ]
        
        if let seasons = query.seasonsIncluded {
            params[Keys.seasonsIncluded.rawValue] = seasons
        }
        
        if let episodes = query.episodesIncluded {
            params[Keys.episodesIncluded.rawValue] = episodes
        }
        
        if let excluded = fieldsFilter.excludedFields, !excluded.isEmpty {
            params[Keys.excludeFields.rawValue] = excluded.joined(separator: ",")
        }
        
        if let included = fieldsFilter.includedFields, !included.isEmpty {
            params[Keys.includeFields.rawValue] = included.joined(separator: ",")
        }
        
        return params
    }
}


// MARK: - Seasons
extension FetchAssetById {
    
    // MARK: Seasons
    public var seasonsIncluded: Bool {
        return query.seasonsIncluded ?? false
    }
    
    // Set to true to include seasons for the asset in the response. Only applicable if the asset is a tv show.
    public func filter(includeSeasons value: Bool) -> FetchAssetById {
        var old = self
        old.query = Query(seasons: value, episodes: query.episodesIncluded)
        return old
    }
    
    public var episodesIncluded: Bool {
        return query.episodesIncluded ?? false
    }
    
    // Set to true to include episodes for the asset in the response. Only applicable if the asset is a tv show. Setting this to true will cause seasons to be includeSeasons true.
    public func filter(includeEpisodes value: Bool) -> FetchAssetById {
        var old = self
        old.query = Query(seasons: query.seasonsIncluded, episodes: value)
        return old
    }
    
}

// MARK: Internal Query
extension FetchAssetById {
    internal struct Query {
        internal let episodesIncluded: Bool?
        internal let seasonsIncluded: Bool?
        
        internal init(seasons: Bool? = nil, episodes: Bool? = nil) {
            self.seasonsIncluded = seasons
            self.episodesIncluded = episodes
        }
    }
    
}

// MARK: - Request
extension FetchAssetById {
    public func request() -> ExposureRequest {
        return request(.get, encoding: ExposureURLEncoding.default)
    }
}
