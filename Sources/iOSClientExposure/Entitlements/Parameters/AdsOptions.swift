//
//  AdsOptionsRequest.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-11-11.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation
import UIKit

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

    /// user id from our platform
    public let uid: String?
    
    public let autoplay: Bool?
    
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
    
    /// Desktop, Tablet, Mobile or TV
    public let deviceType: String?
    
    /// Device model : ( atv-1:atv-1: 1st generation (A1218) / atv-4k-2: 4K 2nd generation (A2169) etc. )
    public let deviceModel: String?
    
    /// Device Model number ( `A` number of Apple TV : A1218: 1st generation / A2169: 4K 2nd generation etc.)
    public let deviceModelNumber: String?
    
    /// Device width
    public let width: NSNumber?
    
    /// Device height
    public let height: NSNumber?
    
    /// User advertising ID
    public let ifa: String?
    
    /// type of the advertising identifier : ex : If user has authorised tracking ,  ifaType  = "idfa"
    public let ifaType: String?
    
    /// True if the user opted-out of ad tracking:
    public let limitAdTracking: Bool?
    
    /// App bundle id
    public let appBundle: String?
    
    /// App name
    public let appName: String?
    
    /// App store url
    public let appStoreUrl: String?
    
    /// a flag for European Union traffic consenting to advertising
    public let gdprOptin: Bool?
    
    /// Specifies optional AdsOptions
    /// - Parameters:
    ///   - uid: user id from our platform
    ///   - autoplay: autoplay true / false
    ///   - latitude: latitude
    ///   - longitude: longitude
    ///   - mute: mute
    ///   - consent: consent
    ///   - deviceMake: deviceMake
    ///   - deviceType: Desktop, Tablet, Mobile or TV
    ///   - width: Device width
    ///   - height: Device height
    ///   - ifa: ifa
    ///   - appBundle: app bundle id
    ///   - appName: app name
    ///   - appStoreUrl: appstore url
    ///   - gdprOptin: gdprOptin
    public init(uid:String? = nil, autoplay: Bool? = nil,  latitude:NSNumber? = nil , longitude:NSNumber? = nil ,  mute:Bool? = nil , consent:String? = nil , deviceMake:String? = nil, deviceType: String? = nil, deviceModel: String? = nil, deviceModelNumber: String? = nil, width: NSNumber? = nil, height: NSNumber? = nil, ifa:String? = nil, ifaType:String? = nil, limitAdTracking: Bool? = nil, appBundle: String? = nil, appName: String? = nil, appStoreUrl: String? = nil, gdprOptin:Bool? = nil ) {
        
        self.uid = uid
        self.autoplay = autoplay
        self.latitude = latitude
        self.longitude = longitude
        self.mute = mute
        self.consent = consent
        self.deviceMake = deviceMake
        self.deviceType = deviceType
        self.width = width
        self.height = height
        self.ifa = ifa
        self.ifaType = ifaType
        self.limitAdTracking = limitAdTracking
        self.appName = appName
        self.appBundle = appBundle
        self.appStoreUrl = appStoreUrl
        self.gdprOptin = gdprOptin
        self.deviceModel = deviceModel
        self.deviceModelNumber = deviceModelNumber
    }
    
    
    var dictionaryRepresentation: [String: Any] {
    
        /// Device specific information
        let device: Device = Device()
        
        
        var returnString: [String: Any] = [:]
        
        if let uid = uid {
            returnString["uid"] = uid
        }
        
        if let autoplay = autoplay {
            returnString["autoplay"] = autoplay
        }
        
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
        } else {
            returnString["deviceMake"] = device.manufacturer
        }
        
        if let deviceType = deviceType {
            returnString["deviceType"] = deviceType
        } else {
            returnString["deviceType"] = device.type.ssaiDeviceType
        }
        
        if let deviceModel = deviceModel {
            returnString["deviceModel"] = deviceModel
        } else {
            // Should not set by the SDK at the moment
            // returnString["deviceModel"] = UIDevice.current.appleTVModel
        }
        
        if let deviceModelNumber = deviceModelNumber {
            returnString["deviceModelNumber"] = deviceModelNumber
        } else {
            // Should not set by the SDK at the moment
            // returnString["deviceModelNumber"] = UIDevice.current.appleTVModelNumber
        }
        
        if let width = width {
            returnString["width"] = width
        } else {
            returnString["width"] = NSNumber(integerLiteral: device.width)
        }
        
        if let height = height {
            returnString["height"] = height
        } else {
            returnString["height"] = NSNumber(integerLiteral: device.height)
        }
        
        if let appName = appName {
            returnString["appName"] = appName
        }
        
        if let appBundle = appBundle {
            returnString["appBundle"] = appBundle
        }
        
        if let appStoreUrl = appStoreUrl {
            returnString["appStoreUrl"] = appStoreUrl
        } 
        
        if let ifa = ifa {
            returnString["ifa"] = ifa
        } else {
            returnString["ifa"] = device.deviceId
        }
        
        if let ifaType = ifaType {
            returnString["ifaType"] = ifaType
        }
        
        if let limitAdTracking = limitAdTracking {
            returnString["limitAdTracking"] = limitAdTracking
        }
        
        if let gdprOptin = gdprOptin {
            returnString["gdprOptin"] = gdprOptin
        }
        
        // Assumed that iOS / tvOS will only support below formats & drms
        returnString["supportedFormats"] = "hls,mp3"
        returnString["supportedDrms"] = "fairplay"
        
        return  returnString
    }
}
