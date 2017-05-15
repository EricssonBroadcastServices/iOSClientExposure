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
        return [:]
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    internal let query: Query
    
    
    // MARK: Seasons
    public var seasonsIncluded: Bool {
        get {
            switch query.seasons {
            case .none: return false
            default: return true
            }
        }
    }
    
    // Set to true to include seasons for the asset in the response. Only applicable if the asset is a tv show.
    public func include(seasons value: Bool) -> FetchAssetById {
        // Only process if value changes
        guard seasonsIncluded != value else { return self }
        
        if !value {
            // Turning off seasons turns off episodes as well
            let query = Query(with: self.query, seasons: .none)
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
        get {
            switch query.seasons {
            case .episodes: return true
            default: return false
            }
        }
    }
    
    // Set to true to include episodes for the asset in the response. Only applicable if the asset is a tv show. Setting this to true will cause seasons to be includeSeasons true.
    public func include(episodes value: Bool) -> FetchAssetById {
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
    public var fieldSet: FieldSet {
        return query.fieldSet
    }
    
    public func filter(fieldSet: FieldSet) -> FetchAssetById {
        let query = Query(with: self.query, fieldSet: fieldSet)
        return FetchAssetById(request: self, query: query)
    }
    
    
    public var fieldsIncluded: [String] {
        return query.includedFields
    }
    // The set of fields to include by default.
    public func include(fields: [String]) -> FetchAssetById {
        let query = Query(with: self.query, includedFields: fields)
        return FetchAssetById(request: self, query: query)
    }
    
    public var fieldsExcluded: [String] {
        return query.excludedFields
    }
    // List of fields to remove from the response.
    public func exclude(fields: [String]) -> FetchAssetById {
        let query = Query(with: self.query, excludedFields: fields)
        return FetchAssetById(request: self, query: query)
    }
    
    //
    public var onlyPublished: Bool {
        return query.onlyPublished
    }
    public func filter(onlyPublished: Bool) -> FetchAssetById {
        let query = Query(with: self.query, onlyPublished: onlyPublished)
        return FetchAssetById(request: self, query: query)
    }
    
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
    public enum FieldSet {
        case none
        case partial
        case all
    }
    
    internal struct Query {
        internal enum IncludeSeasons {
            case none
            case seasons
            case episodes
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
