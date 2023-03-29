//
//  PlayEnigmaAdsAsset.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-11-18.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation
import UIKit

/// Play request for an asset with ads options
public struct PlayEnigmaAdsAsset: ExposureType {
    
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
    
    public let includeAdsOptions: AdsOptions
    
    // Custom Ad params
    public let customAdParams: [String: Any]?
    
    /// manufacturer of device such as `Apple`
    public let deviceMake: String?
    
    /// Device model : ( appletv-11-2 / iphone-12-5 etc. )
    public let deviceModel: String?
    
    internal init(assetId: String, environment: Environment, sessionToken: SessionToken, includeAdsOptions: AdsOptions, adobePrimetimeMediaToken: String?, materialProfile: String?, customAdParams: [String: Any]?, deviceMake: String? = nil , deviceModel:String? = nil) {
        self.assetId = assetId
        self.environment = environment
        self.sessionToken = sessionToken
        self.includeAdsOptions = includeAdsOptions
        self.adobePrimetimeMediaToken = adobePrimetimeMediaToken
        self.materialProfile = materialProfile
        self.customAdParams = customAdParams
        self.deviceMake = deviceMake
        self.deviceModel = deviceModel
    }
    
    public var endpointUrl: String {
        var newEnvironment = environment
        newEnvironment.version = "v2"
        return newEnvironment.apiUrl + "/entitlement/" + assetId + "/play"
    }
    
    public var parameters: [String: Any]? {
        
        var parameters = includeAdsOptions.dictionaryRepresentation
        
        if let materialProfile = materialProfile {
            parameters["materialProfile"] = materialProfile
        }
        
        if let customAdParams = customAdParams {
            for adParam in customAdParams {
                parameters[adParam.key] = adParam.value
            }
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

extension PlayEnigmaAdsAsset {
    /// `PlayVod` request is specified as a `.post`
    ///
    /// - returns: `ExposureRequest` with request specific data
    public func request() -> ExposureRequest<Response> {
        return request(.get)
    }
}
