//
//  DownloadVod.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-09-18.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import UIKit

/// Request a `PlaybackEntitlement` for *DownloadVod*.
///
/// If the *entitlement checks* pass, will return the information needed to initialize the download for the requested streaming format.
///
/// Default streaming format is:
/// * `drm` FAIRPLAY
/// * `format` HLS
public struct DownloadVod: ExposureType, DRMRequest {
    public typealias Response = PlayBackEntitlementV2

    /// Id of the asset to play
    public let assetId: String

    /// `Environment` to use
    public let environment: Environment

    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken

    /// `DRM` and *format* to request.
    public var playRequest: PlayRequest
    
    /// manufacturer of device such as `Apple`
    public let deviceMake: String?
    
    /// Device model : ( appletv-11-2 / iphone-12-5 etc. )
    public let deviceModel: String?
    

    internal init(assetId: String, playRequest: PlayRequest = PlayRequest(), environment: Environment, sessionToken: SessionToken, deviceMake: String? = nil , deviceModel:String? = nil ) {
        self.assetId = assetId
        self.playRequest = playRequest
        self.environment = environment
        self.sessionToken = sessionToken
        self.deviceMake = deviceMake
        self.deviceModel = deviceModel
    }

    public var endpointUrl: String {
        var environmentV2 = environment
        environmentV2.version = "v2"
        return environmentV2.apiUrl + "/entitlement/" + assetId + "/download"
    }

    public var parameters: [String:Any] {
        
        // Device specific manifest filtering params
        var returnString: [String: Any] = [:]
        
        let device: Device = Device()
        if let deviceMake = deviceMake {
            returnString["deviceMake"] = deviceMake
        } else {
            returnString["deviceMake"] = device.manufacturer.lowercased()
        }

        if let deviceModel = deviceModel {
            returnString["deviceModel"] = deviceModel
        } else {
            returnString["deviceModel"] = UIDevice.current.appleDeviceModel
        }
        
        return returnString
    }

    public var headers: [String: String]? {
        return sessionToken.authorizationHeader
    }
}

extension DownloadVod {
    /// `DownloadVod` request is sp ecified as a `.post`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
