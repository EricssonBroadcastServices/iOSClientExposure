//
//  FetchAssetList.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-17.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct FetchAssetList: Exposure, FilteredFields, FilteredPublish, PageableResponse, FilteredDevices, SortedResponse {
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
    
    public var sortDescription: SortDescription
    
    public let environment: Environment
    internal var query: Query
    
    
    internal init(environment: Environment) {
        self.environment = environment
        self.fieldsFilter = FieldsFilter()
        self.publishFilter = PublishFilter()
        self.pageFilter = PageFilter()
        self.deviceFilter = DeviceFilter()
        
        self.sortDescription = SortDescription()
        
        self.query = Query()
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
        
        if let assetType = query.assetType {
            params[Keys.assetType.rawValue] = assetType.queryParam
        }
        
        if let sort = sortDescription.descriptors {
            // Query string is keys separated by ",".
            // Any descending key should include a "-" sign as a prefix.
            params[Keys.sort.rawValue] = sort
                .map{ $0.ascending ? "" : "-" + $0.key }
                .joined(separator: ",")
        }
        
        return params
    }
}

// MARK: - Query
extension FetchAssetList {
    public typealias AssetType = Asset.AssetType
    
    // MARK: AssetType
    public var assetType: AssetType? {
        return query.assetType
    }
    
    public func filter(on assetType: AssetType) -> FetchAssetList {
        var old = self
        old.query = Query(assetType: assetType)
        return old
    }
}

// MARK: - Internal Query
extension FetchAssetList {
    internal struct Query {
        internal let assetType: AssetType?
        
        init(assetType: AssetType? = nil) {
            self.assetType = assetType
        }
    }
}
