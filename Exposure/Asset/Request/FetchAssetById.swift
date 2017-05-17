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
    
    internal init(environment: Environment, assetId: String) {
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
        return [
            Keys.onlyPublished.rawValue: publishFilter.onlyPublished,
            Keys.fieldSet.rawValue: fieldsFilter.fieldSet.rawValue,
            Keys.excludeFields.rawValue: fieldsFilter.excludedFields.joined(separator: ","),
            Keys.includeFields.rawValue: fieldsFilter.includedFields.joined(separator: ","),
            Keys.seasonsIncluded.rawValue: query.seasons.seasonsIncluded,
            Keys.episodesIncluded.rawValue: query.seasons.episodesIncluded
        ]
    }
}


// MARK: - Seasons
extension FetchAssetById {
    
    // MARK: Seasons
    public var seasonsIncluded: Bool {
        return query.seasons.seasonsIncluded
    }
    
    // Set to true to include seasons for the asset in the response. Only applicable if the asset is a tv show.
    public func filter(includeSeasons value: Bool) -> FetchAssetById {
        // Only process if value changes
        guard seasonsIncluded != value else { return self }
        
        if !value {
            // Turning off seasons turns off episodes as well
            var old = self
            old.query = Query(seasons: .neither)
            return old
        }
        else {
            // Activate seasons
            var old = self
            old.query = Query(seasons: .seasons)
            return old
        }
    }
    
    public var episodesIncluded: Bool {
        return query.seasons.episodesIncluded
    }
    
    // Set to true to include episodes for the asset in the response. Only applicable if the asset is a tv show. Setting this to true will cause seasons to be includeSeasons true.
    public func filter(includeEpisodes value: Bool) -> FetchAssetById {
        // Only process if value changes
        guard episodesIncluded != value else { return self }
        
        if value {
            // Turning on Episodes turns on Seasons as well
            var old = self
            old.query = Query(seasons: .episodes)
            return old
        }
        else {
            // Turn off Episodes, but keep seasons active
            var old = self
            old.query = Query(seasons: .seasons)
            return old
        }
    }
    
}

// MARK: Internal Query
extension FetchAssetById {
    internal struct Query {
        internal enum IncludeSeasons {
            case neither
            case seasons
            case episodes
            
            var episodesIncluded: Bool {
                get {
                    switch self {
                    case .episodes: return true
                    default: return false
                    }
                }
            }
            
            var seasonsIncluded: Bool {
                get {
                    switch self {
                    case .neither: return false
                    default: return true
                    }
                }
            }
        }
        
        internal let seasons: IncludeSeasons
        
        internal init(seasons: IncludeSeasons = .seasons) {
            self.seasons = seasons
        }
    }
    
}

// MARK: - Request
extension FetchAssetById {
    public func request() -> ExposureRequest {
        return request(.get, encoding: URLEncoding.default)
    }
    
}
