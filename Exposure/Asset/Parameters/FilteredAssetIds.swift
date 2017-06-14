//
//  FilteredAssetIds.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation


public protocol FilteredAssetIds {
    var assetIdFilter: AssetIdFilter { get set }
}

extension FilteredAssetIds {
    // MARK: AssetIds
    public var assetIds: [String]? {
        return assetIdFilter.assetIds
    }
    
    public func filter(onlyAssetIds: [String]?) -> Self {
        var old = self
        old.assetIdFilter = AssetIdFilter(assetIds: onlyAssetIds)
        return old
    }
}

public struct AssetIdFilter {
    internal let assetIds: [String]?
    
    internal init(assetIds: [String]? = nil) {
        self.assetIds = assetIds
    }
}
