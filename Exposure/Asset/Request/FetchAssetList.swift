//
//  FetchAssetList.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-17.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct FetchAssetList: Exposure, FilteredFields, FilteredPublish, PageableResponse {
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
    
    public let environment: Environment
    internal var query: Query
    
    
    internal init(environment: Environment) {
        self.environment = environment
        self.fieldsFilter = FieldsFilter()
        self.publishFilter = PublishFilter()
        self.pageFilter = PageFilter()
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
    }
    
    internal var queryParams: [String: Any] {
        var params:[String: Any] = [
            Keys.onlyPublished.rawValue: publishFilter.onlyPublished,
            Keys.fieldSet.rawValue: fieldsFilter.fieldSet.rawValue,
            Keys.excludeFields.rawValue: fieldsFilter.excludedFields.joined(separator: ","),
            Keys.includeFields.rawValue: fieldsFilter.includedFields.joined(separator: ","),
            Keys.pageSize.rawValue: pageFilter.size,
            Keys.pageNumber.rawValue: pageFilter.page
        ]
        
        if let assetType = query.assetType {
            params[Keys.assetType.rawValue] = assetType
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
        return self
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
