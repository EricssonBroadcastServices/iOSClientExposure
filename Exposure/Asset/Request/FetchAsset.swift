//
//  FetchAsset.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Alamofire

public struct FetchAsset {
    public let environment: Environment
}

extension FetchAsset {
    public func with(id: String) -> FetchAssetById {
        return FetchAssetById(environment: environment,
                              assetId: id)
    }
}

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
    
    
    public let environment: Environment
    public let assetId: String
    
    internal init(environment: Environment, assetId: String) {
        self.environment = environment
        self.assetId = assetId
    }
}

extension FetchAssetById {
    public func request() -> ExposureRequest {
        return request(.get, encoding: URLEncoding.default)
    }
}
