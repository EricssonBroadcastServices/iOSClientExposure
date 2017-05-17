//
//  FetchAssetList.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-17.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct FetchAssetList: FilteredFields, FilteredPublish {//: Exposure {
    
    public var fieldsFilter: FieldsFilter
    public var publishFilter: PublishFilter
    
    public let environment: Environment
    internal var query: Query
    
    
    internal init(environment: Environment) {
        self.environment = environment
        self.fieldsFilter = FieldsFilter()
        self.publishFilter = PublishFilter()
        self.query = Query()
    }
}

// MARK: - Query
extension FetchAssetList {
    public typealias AssetType = Asset.AssetType
    
    // MARK: AssetType
    public var assetTypes: [AssetType] {
        return query.assetTypes
    }
    
    public func filter(on assetTypes: [AssetType]) -> FetchAssetList {
        var old = self
        old.query = Query(with: self.query, assetTypes: assetTypes)
        return self
    }
    
    public func filter(on assetType: AssetType) -> FetchAssetList {
        return filter(on: [assetType])
    }
}

// MARK: - Internal Query
extension FetchAssetList {
    internal struct Query {
        internal let assetTypes: [AssetType]
        
        init(assetTypes: [AssetType] = []) {
            self.assetTypes = assetTypes
        }
        
        init(with query: Query, assetTypes: [AssetType]? = nil) {
            self.assetTypes = assetTypes ?? query.assetTypes
        }
    }
}
