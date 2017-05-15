//
//  FetchAsset.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct FetchAsset {
    public let environment: Environment
}

extension FetchAsset {
    public func filter(assetId: String) -> FetchAssetById {
        return FetchAssetById(environment: environment,
                              assetId: assetId)
    }
}
