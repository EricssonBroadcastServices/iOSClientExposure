//
//  FetchAssetById.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

public struct FetchAssetById: Exposure {
    public typealias Response = Asset
    
    public var endpointUrl: String {
        return environment.apiUrl + "/content/asset/" + assetId
    }
    
    public var parameters: [String: Any] {
        return query.toQueryParams
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    internal let query: Query
    
    public let environment: Environment
    public let assetId: String
    
    internal init(environment: Environment, assetId: String) {
        self.environment = environment
        self.assetId = assetId
        self.query = Query()
    }
}

// MARK: - Query
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
            let query = Query(with: self.query, seasons: .neither)
            return FetchAssetById(request: self, query: query)
        }
        else {
            if episodesIncluded {
                // Turning on seasons while episodes is allready on does nothing
                return self
            }
            else {
                // Activate seasons
                let query = Query(with: self.query, seasons: .seasons)
                return FetchAssetById(request: self, query: query)
            }
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
            let query = Query(with: self.query, seasons: .episodes)
            return FetchAssetById(request: self, query: query)
        }
        else {
            // Turn off Episodes, but keep seasons active
            let query = Query(with: self.query, seasons: .seasons)
            return FetchAssetById(request: self, query: query)
        }
    }
    
    // MARK: Fields
    public enum FieldSet: String {
        case none = "NONE"
        case partial = "PARTIAL"
        case all = "ALL"
    }
    
    public var fieldSet: FieldSet {
        return query.fieldSet
    }
    
    public func filter(includeFieldSet: FieldSet) -> FetchAssetById {
        let query = Query(with: self.query, fieldSet: fieldSet)
        return FetchAssetById(request: self, query: query)
    }
    
    
    public var fieldsIncluded: [String] {
        return query.includedFields
    }
    // The set of fields to include by default.
    public func filter(includeFields fields: [String]) -> FetchAssetById {
        let query = Query(with: self.query, includedFields: fields)
        return FetchAssetById(request: self, query: query)
    }
    
    public var fieldsExcluded: [String] {
        return query.excludedFields
    }
    // List of fields to remove from the response.
    public func filter(excludeFields fields: [String]) -> FetchAssetById {
        let query = Query(with: self.query, excludedFields: fields)
        return FetchAssetById(request: self, query: query)
    }
    
    // MARK: Published
    public var onlyPublished: Bool {
        return query.onlyPublished
    }
    public func filter(onlyPublished: Bool) -> FetchAssetById {
        let query = Query(with: self.query, onlyPublished: onlyPublished)
        return FetchAssetById(request: self, query: query)
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
        internal let fieldSet: FieldSet
        internal let includedFields: [String]
        internal let excludedFields: [String]
        internal let onlyPublished: Bool
        
        init(seasons: IncludeSeasons = .episodes, fieldSet: FieldSet = .all, includedFields: [String] = [], excludedFields: [String] = [], onlyPublished: Bool = true) {
            self.seasons = seasons
            self.fieldSet = fieldSet
            self.includedFields = includedFields
            self.excludedFields = excludedFields
            self.onlyPublished = onlyPublished
        }
        
        init(with query: Query, seasons: IncludeSeasons? = nil, fieldSet: FieldSet? = nil, includedFields: [String]? = nil, excludedFields: [String]? = nil, onlyPublished: Bool? = nil) {
            self.seasons = seasons ?? query.seasons
            self.fieldSet = fieldSet ?? query.fieldSet
            self.includedFields = includedFields ?? query.includedFields
            self.excludedFields = excludedFields ?? query.excludedFields
            self.onlyPublished = onlyPublished == query.onlyPublished
        }
        
        
        internal enum Keys: String {
            case includeEpisodes = "includeEpisodes"
            case includeSeasons = "includeSeasons"
            case fieldSet = "fieldSet"
            case excludeFields = "excludeFields"
            case includeFields = "includeFields"
            case onlyPublished = "onlyPublished"
        }
        
        internal var toQueryParams: [String: Any] {
            return [
                Keys.includeEpisodes.rawValue: seasons.episodesIncluded,
                Keys.includeSeasons.rawValue: seasons.seasonsIncluded,
                Keys.fieldSet.rawValue: fieldSet.rawValue,
                Keys.excludeFields.rawValue: excludedFields.joined(separator: ","),
                Keys.includeFields.rawValue: includedFields.joined(separator: ","),
                Keys.onlyPublished.rawValue: onlyPublished
            ]
        }
    }
    
    internal init(request: FetchAssetById, query: Query) {
        self.environment = request.environment
        self.assetId = request.assetId
        self.query = query
    }
}

// MARK: - Request
extension FetchAssetById {
    public func request() -> ExposureRequest {
        return request(.get, encoding: URLEncoding.default)
    }
    
}
