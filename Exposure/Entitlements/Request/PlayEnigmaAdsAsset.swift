//
//  PlayEnigmaAdsAsset.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-11-18.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation


/// Play request for an asset with ads options
public struct PlayEnigmaAdsAsset: ExposureType {
    
    public typealias Response = PlayBackEntitlementV2
    
    /// Id of the asset to play
    public let assetId: String
    
    /// `Environment` to use
    public let environment: Environment
    
    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken
    
    public let includeAdsOptions: AdsOptions
    
    internal init(assetId: String, environment: Environment, sessionToken: SessionToken, includeAdsOptions: AdsOptions) {
        self.assetId = assetId
        self.environment = environment
        self.sessionToken = sessionToken
        self.includeAdsOptions = includeAdsOptions
    }
    
    public var endpointUrl: String {
        var newEnvironment = environment
        newEnvironment.version = "v2"
        return newEnvironment.apiUrl + "/entitlement/" + assetId + "/play"
    }
    
    
    public var parameters: AdsOptions {
        return includeAdsOptions
    }
    

    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension PlayEnigmaAdsAsset {
    /// `PlayVod` request is specified as a `.post`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
