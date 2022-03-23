//
//  FilteredAssetIds.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Defines an *Exposure request* filter on specific *assetId*s.
public protocol FilteredAssetIds {
    /// Filter to apply
    var assetIdFilter: AssetIdFilter { get set }
}

extension FilteredAssetIds {
    /// Asset ids to filter by, or `nil`
    public var assetIds: [String]? {
        return assetIdFilter.assetIds
    }
    
    /// Specify the *assetId*s to include. Every asset not matching the supplied *id*s will be filtered out.
    ///
    /// - parameter onlyAssetIds: strict filter on these *assetId*s
    /// - returns: `Self`
    public func filter(onlyAssetIds: [String]?) -> Self {
        var old = self
        old.assetIdFilter = AssetIdFilter(assetIds: onlyAssetIds)
        return old
    }
}

/// Used internally to configure the assetId filter
public struct AssetIdFilter {
    /// Asset ids to filter by, or `nil`
    internal let assetIds: [String]?
    
    internal init(assetIds: [String]? = nil) {
        self.assetIds = assetIds
    }
}
