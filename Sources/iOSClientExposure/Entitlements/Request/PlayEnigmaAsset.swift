//
//  PlayAsset.swift
//  Exposure-iOS
//
//  Created by Udaya Sri Senarathne on 2019-04-10.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation
import UIKit

/// Request a `PlaybackEntitlementV2` for *Asset* playback.
///
/// If the *entitlement checks* pass, will return the information needed to initialize the player for the requested streaming format.
///
/// Default streaming format is:
/// * `drm` FAIRPLAY
/// * `format` HLS
public struct PlayEnigmaAsset: ExposureType {
    
    public typealias Response = PlayBackEntitlementV2
    
    /// Id of the asset to play
    public let assetId: String
    
    /// `Environment` to use
    public let environment: Environment
    
    /// `SessionToken` identifying the user making the request
    public let sessionToken: SessionToken
    
    /// X-Adobe-Primetime-MediaToken
    public let adobePrimetimeMediaToken: String?
    
    // used to play a specific material variant : "default" material contains a full length movie, and a "TRAILER" material might contain only an extract: a virtual subclip generated using the VOD to VOD flow)
    public let materialProfile: String?
    
    /// manufacturer of device such as `Apple`
    public let deviceMake: String?
    
    /// Device model : ( appletv-11-2 / iphone-12-5 etc. )
    public let deviceModel: String?

    internal init(assetId: String, environment: Environment, sessionToken: SessionToken, adobePrimetimeMediaToken: String?, materialProfile: String?, deviceMake: String? = nil , deviceModel:String? = nil ) {
        self.assetId = assetId
        self.environment = environment
        self.sessionToken = sessionToken
        self.adobePrimetimeMediaToken = adobePrimetimeMediaToken
        self.materialProfile = materialProfile
        self.deviceMake = deviceMake
        self.deviceModel = deviceModel
    }
    
    public var endpointUrl: String {
        var newEnvironment = environment
        newEnvironment.version = "v2"
        return newEnvironment.apiUrl + "/entitlement/" + assetId + "/play"
    }
    
    public var parameters: [String: Any] {
        var parameters: [String: String] = [:]
        
        // Adding `supportedFormats` & `supportedDrms` to parameters
        parameters["supportedFormats"] = "hls,mp3"
        parameters["supportedDrms"] = "fairplay"
        
        // Add materialProfile if available
        if let materialProfile = materialProfile {
            parameters["materialProfile"] = materialProfile
        }
        
        // Device specific manifest filtering params
        let device: Device = Device()
        
        if let deviceMake = deviceMake {
            parameters["deviceMake"] = deviceMake
        } else {
            parameters["deviceMake"] = device.manufacturer.lowercased()
        }
        
        if let deviceModel = deviceModel {
            parameters["deviceModel"] = deviceModel
        } else {
            parameters["deviceModel"] = UIDevice.current.appleDeviceModel
        }
        
        return parameters
    }
    
    
    /// Headers to apply
    public var headers: [String: String]? {
        var result: [String: String] = [:]
        
        if let adobePrimeTimeToken = adobePrimetimeMediaToken {
             result["X-Adobe-Primetime-MediaToken"] = adobePrimeTimeToken
        }
        sessionToken.authorizationHeader.forEach{ result[$0] = $1 }
        
        
        return result.isEmpty ? nil : result
    }
    
}

extension PlayEnigmaAsset {
    /// `PlayVod` request is specified as a `.post`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {

        return request(.get)
    }
}
