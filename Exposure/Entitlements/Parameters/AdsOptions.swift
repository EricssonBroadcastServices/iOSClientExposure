//
//  AdsOptionsRequest.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-11-11.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation


/// Client / device specific information that can be used for ad targeting
///
/// * `latitude` provide GPS based geo-location for location based ad targeting (optional) e.g. lat=33.543682 long=-86.779633
/// * `longitude` provide GPS based geo-location for location based ad targeting (optional) e.g. lat=33.543682 long=-86.779633
/// * `mute` indicate whether player is muted or not
/// * `consent` a consent string passed from various Consent Management Platforms (CMP’s)
/// * `deviceMake` manufacturer of device such as Apple or Samsung
/// * `ifa` User device ID
/// * `gdprOptin` a flag for European Union traffic consenting to advertising
public struct AdsOptions {
    
    /// provide GPS based geo-location for location based ad targeting (optional) e.g. lat=33.543682 long=-86.779633
    public let latitude: NSNumber?
    

    /// provide GPS based geo-location for location based ad targeting (optional) e.g. lat=33.543682 long=-86.779633
    public let longitude: NSNumber?
    
    
    /// indicate whether player is muted or not
    public let mute: Bool?
    
    
    /// a consent string passed from various Consent Management Platforms (CMP’s)
    public let consent: String?
    
    
    /// manufacturer of device such as Apple or Samsung
    public let deviceMake: String?
    
    
    /// User device ID
    public let ifa: String?
    
    
    /// a flag for European Union traffic consenting to advertising
    public let gdprOptin: Bool?
    
    
    /// Specifies optional AdsOptions
    /// - Parameters:
    ///   - latitude: latitude
    ///   - longitude: longitude
    ///   - mute: mute
    ///   - consent: consent
    ///   - deviceMake: deviceMake
    ///   - ifa: ifa
    ///   - gdprOptin: gdprOptin
    public init(latitude:NSNumber? = nil , longitude:NSNumber? = nil ,  mute:Bool? = nil , consent:String? = nil , deviceMake:String? = nil, ifa:String? = nil , gdprOptin:Bool? = nil ) {
        self.latitude = latitude
        self.longitude = longitude
        self.mute = mute
        self.consent = consent
        self.deviceMake = deviceMake
        self.ifa = ifa
        self.gdprOptin = gdprOptin
    }
    
    
    var dictionaryRepresentation: [String: Any] {
        
        var returnString: [String: Any] = [:]
        
        if let latitude = latitude {
            returnString["latitude"] = latitude
        }
        
        if let longitude = longitude {
            returnString["longitude"] = longitude
        }
        
        if let mute = mute {
            returnString["mute"] = mute
        }
        
        if let consent = consent {
            returnString["consent"] = consent
        }
        
        if let deviceMake = deviceMake {
            returnString["deviceMake"] = deviceMake
        }
        
        if let ifa = ifa {
            returnString["ifa"] = ifa
        }
        
        
        if let gdprOptin = gdprOptin {
            returnString["gdprOptin"] = gdprOptin
        }
       return  returnString
    }
}
