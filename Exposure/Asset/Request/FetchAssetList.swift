//
//  FetchAssetList.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-17.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

public struct FetchAssetList: Exposure, FilteredFields, FilteredPublish, PageableResponse, FilteredDevices, SortedResponse, ElasticSearch {
    public typealias Response = AssetList
    
    public var endpointUrl: String {
        return environment.apiUrl + "/content/asset"
    }
    
    public var parameters: [String: Any] {
        return queryParams
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public var fieldsFilter: FieldsFilter
    public var publishFilter: PublishFilter
    public var pageFilter: PageFilter
    public var deviceFilter: DeviceFilter
    public var elasticSearchQuery: ElasticSearchQuery
    
    public var sortDescription: SortDescription
    
    public let environment: Environment
    internal var internalQuery: Query
    
    
    internal init(environment: Environment) {
        self.environment = environment
        self.fieldsFilter = FieldsFilter()
        self.publishFilter = PublishFilter()
        self.pageFilter = PageFilter()
        self.deviceFilter = DeviceFilter()
        self.elasticSearchQuery = ElasticSearchQuery()
        
        self.sortDescription = SortDescription()
        
        self.internalQuery = Query()
    }
    
    internal enum Keys: String {
        case onlyPublished = "onlyPublished"
        case fieldSet = "fieldSet"
        case excludeFields = "excludeFields"
        case includeFields = "includeFields"
        case pageSize = "pageSize"
        case pageNumber = "pageNumber"
        case assetType = "assetType"
        case deviceType = "deviceType"
        case sort = "sort"
        case query = "query"
        case deviceQuery = "deviceQuery"
        case publicationQuery = "publicationQuery"
        case assetIds = "assetIds"
    }
    
    internal var queryParams: [String: Any] {
        var params:[String: Any] = [
            Keys.onlyPublished.rawValue: publishFilter.onlyPublished,
            Keys.fieldSet.rawValue: fieldsFilter.fieldSet.rawValue,
            Keys.pageSize.rawValue: pageFilter.size,
            Keys.pageNumber.rawValue: pageFilter.page
        ]
        
        if let excluded = fieldsFilter.excludedFields, !excluded.isEmpty {
            // Query string is keys separated by ","
            params[Keys.excludeFields.rawValue] = excluded.joined(separator: ",")
        }
        
        if let included = fieldsFilter.includedFields, !included.isEmpty {
            // Query string is keys separated by ","
            params[Keys.includeFields.rawValue] = included.joined(separator: ",")
        }
        
        if let deviceType = deviceFilter.deviceType {
            params[Keys.deviceType.rawValue] = deviceType.queryParam
        }
        
        if let assetType = internalQuery.assetType {
            params[Keys.assetType.rawValue] = assetType.queryParam
        }
        
        if let sort = sortDescription.descriptors {
            // Query string is keys separated by ",".
            // Any descending key should include a "-" sign as a prefix.
            params[Keys.sort.rawValue] = sort
                .map{ $0.ascending ? "" : "-" + $0.key }
                .joined(separator: ",")
        }
        
        if let querySearch = elasticSearchQuery.query {
            params[Keys.query.rawValue] = querySearch
        }
        
        if let deviceQuery = internalQuery.deviceQuery {
            params[Keys.deviceQuery.rawValue] = deviceQuery
        }
        
        if let publicationQuery = internalQuery.publicationQuery {
            params[Keys.publicationQuery.rawValue] = publicationQuery
        }
        
        if let assetIds = internalQuery.assetIds {
            params[Keys.assetIds.rawValue] = assetIds
        }
        
        return params
    }
}

// MARK: - Query
extension FetchAssetList {
    public typealias AssetType = Asset.AssetType
    
    // MARK: AssetType
    public var assetType: AssetType? {
        return internalQuery.assetType
    }
    
    public func filter(on assetType: AssetType) -> FetchAssetList {
        var old = self
        old.internalQuery = Query(previous: internalQuery, assetType: assetType)
        return old
    }
    
    // MARK: AssetIds
    public var assetIds: [String]? {
        return internalQuery.assetIds
    }
    
    public func filter(onlyAssetIds: [String]?) -> FetchAssetList {
        var old = self
        old.internalQuery = Query(previous: internalQuery, assetIds: onlyAssetIds)
        return old
    }
    
    // MARK: Device Query
    public var deviceQuery: String? {
        return internalQuery.deviceQuery
    }
    
    /// The optional query to filter by in fields nested under publications.devices. In the elasticsearch query string query format, I.E: "publications.devices.rights.threeGBlocked:false AND publications.devices.os:IOS"
    public func elasticSearch(deviceQuery string: String?) -> FetchAssetList {
        var old = self
        old.internalQuery = Query(previous: internalQuery, deviceQuery: string)
        return old
    }
    
    // MARK: Publication Query
    public var publicationQuery: String? {
        return internalQuery.publicationQuery
    }
    
    /// The optional query to filter by in fields nested under publications except publications.devices. In the elasticsearch query string query format, I.E: "publications.rights.wifiBlocked:true"
    public func elasticSearch(publicationQuery string: String?) -> FetchAssetList {
        var old = self
        old.internalQuery = Query(previous: internalQuery, publicationQuery: string)
        return old
    }
}

// MARK: - Internal Query
extension FetchAssetList {
    internal struct Query {
        internal let assetType: AssetType?
        internal let assetIds: [String]?
        
        internal let deviceQuery: String?
        internal let publicationQuery: String?
        
        internal init(assetType: AssetType? = nil, assetIds: [String]? = nil, deviceQuery: String? = nil, publicationQuery: String? = nil) {
            self.assetType = assetType
            self.assetIds = assetIds
            self.deviceQuery = deviceQuery
            self.publicationQuery = publicationQuery
        }
        
        internal init(previous: Query, assetType: AssetType? = nil, assetIds: [String]? = nil, deviceQuery: String? = nil, publicationQuery: String? = nil) {
            self.assetType = assetType ?? previous.assetType
            self.assetIds = assetIds ?? previous.assetIds
            self.deviceQuery = deviceQuery ?? previous.deviceQuery
            self.publicationQuery = publicationQuery ?? previous.publicationQuery
        }
    }
}

// MARK: - Request
extension FetchAssetList {
    public func request() -> ExposureRequest {
        return request(.get, encoding: ExposureURLEncoding(destination: .queryString))
    }
}
