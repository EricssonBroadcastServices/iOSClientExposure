//
//  FetchAssetList.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-17.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct FetchAssetList {//: Exposure {
    
    
    internal let query: Query
}

// MARK: - Query
extension FetchAssetList {
    public typealias AssetType = Asset.AssetType
    
    // MARK: AssetType
    public var assetTypes: [AssetType] {
        return query.assetTypes
    }
    
    public func filter(on assetTypes: [AssetType]) -> FetchAssetList {
        let query = Query(with: self.query, assetTypes: assetTypes)
        return FetchAssetList(request: self, query: query)
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
    
    internal init(request: FetchAssetList, query: Query) {
        //self.environment = request.environment
        self.query = query
    }
}
