//
//  ValidateDownload.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-25.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Content rights for specific assets are subject to change throughout a `PlaybackEntitlement`s life cycle. `ValidateDownload` offers a method to validate if a user is *entitled* to download an asset.
public struct ValidateDownload: ExposureType, DRMRequest {
    public typealias Response = PlayBackEntitlementV2

    /// Id of the asset to play
    public let assetId: String

    /// `Environment` to use
    public let environment: Environment

    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken

    /// `DRM` and *format* to request.
    public var playRequest: PlayRequest

    internal init(assetId: String, playRequest: PlayRequest = PlayRequest(), environment: Environment, sessionToken: SessionToken) {
        self.assetId = assetId
        self.playRequest = playRequest
        self.environment = environment
        self.sessionToken = sessionToken
    }

    public var endpointUrl: String {
        var environmentV2 = environment
        environmentV2.version = "v2"
        return environmentV2.apiUrl + "/entitlement/" + assetId + "/download"
    }

    public var parameters: [String:Any] {
        return [:]
    }

    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension ValidateDownload {
    internal enum Keys: String {
        case drm = "drm"
        case format = "format"
    }
    
    internal var queryParams: [String: Any] {
        return [
            Keys.drm.rawValue: playRequest.drm,
            Keys.format.rawValue: playRequest.format
        ]
    }
}

extension ValidateDownload {
    /// `ValidateDownload` request is specified as a `.get`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
