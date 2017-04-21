//
//  DeviceInfo.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

extension UIDevice {
    public static func deviceType() -> DeviceInfo.DeviceType {
        return DeviceInfo.DeviceType(model: current.model)
    }
}
public struct DeviceInfo {
    public init(device: Device = Device()) {
        self.device = device
    }
    
    public var deviceId: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    public let device: Device
    
    
    public struct Device {
        public init(name: String? = nil) {
            self.name = name
        }
        
        public var height: Int {
            return Int(UIScreen.main.bounds.size.height)
        }
        
        public var width: Int {
            return Int(UIScreen.main.bounds.size.width)
        }
        
        public var model: Model {
            var size = 0
            sysctlbyname("hw.machine", nil, &size, nil, 0)
            var machine = [CChar](repeating: 0,  count: Int(size))
            sysctlbyname("hw.machine", &machine, &size, nil, 0)
            let modelString = String(cString: machine)
            return Model(model: modelString)
        }
        
        public let name: String?
        public let os: String = "iOS"
        
        public var osVersion: String? {
            let components = UIDevice.current.systemVersion.components(separatedBy: ".")
            switch components.count {
            case 0: return nil
            case 1: return components.first! + ".0"
            case 2: return components.joined(separator: ".")
            default: return components[0] + "." + components[1]
            }
        }
        
        public let manufacturer: String = "Apple"
        
        public var type: DeviceType {
            return UIDevice.deviceType()
        }
    }
}

extension DeviceInfo: JSONEncodable {
    public func toJSON() -> [String: Any] {
        var json: [String: Any] = [:]
        
        json[JSONKeys.device.rawValue] = device.toJSON()
        
        if let deviceId = deviceId {
            // NOTE: Should probably return nil from toJSON if deviceId == nil
            json[JSONKeys.deviceId.rawValue] = deviceId
        }
        
        return json
    }
    
    internal enum JSONKeys: String {
        case deviceId = "deviceId"
        case device = "device"
    }
}

extension DeviceInfo.Device: JSONEncodable {
    public func toJSON() -> [String: Any] {
        var json: [String: Any] = [
            JSONKeys.height.rawValue: height,
            JSONKeys.width.rawValue: width,
            JSONKeys.model.rawValue: model.rawValue,
            JSONKeys.os.rawValue: os,
            JSONKeys.manufacturer.rawValue: manufacturer,
            JSONKeys.type.rawValue: type.rawValue
        ]
        
        if let name = name { json[JSONKeys.name.rawValue] = name }
        if let osVersion = osVersion { json[JSONKeys.osVersion.rawValue] = osVersion }
        
        return json
    }
    
    internal enum JSONKeys: String {
        case height = "height"
        case width = "width"
        case model = "model"
        case os = "os"
        case manufacturer = "manufacturer"
        case type = "type"
        case name = "name"
        case osVersion = "osVersion"
    }
}

extension DeviceInfo {
    public enum DeviceType: String {
        case mobile = "MOBILE"
        case tablet = "TABLET"
        case appleTV = "APPLE_TV"
        
        init(model: String) {
            switch model {
            case "iPhone": self = .mobile
            case "iPad": self = .tablet
            case "AppleTv": self = .appleTV
            default: self = .mobile
            }
        }
    }
}

extension DeviceInfo {
    public enum Model: String {
        case iPhone1G = "iPhone 1G"
        case iPhone3G = "iPhone 3G"
        case iPhone3Gs = "iPhone 3GS"
        case iPhone4 = "iPhone 4"
        case iPhone4Verizon = "Verizon iPhone 4"
        case iPhone4s = "iPhone 4S"
        case iPhone5GSM = "iPhone 5 (GSM)"
        case iPhone5GSMCDMA = "iPhone 5 (GSM+CDMA)"
        case iPhone5cGSM = "iPhone 5c (GSM)"
        case iPhone5cGSMCDMA = "iPhone 5c (GSM+CDMA)"
        case iPhone5sGSM = "iPhone 5s (GSM)"
        case iPhone5sGSMCDMA = "iPhone 5s (GSM+CDMA)"
        case iPhone6 = "iPhone 6"
        case iPhone6Plus = "iPhone 6 Plus"
        case iPhone6s = "iPhone 6s"
        case iPhone6sPlus = "iPhone 6s Plus"
        case iPhoneSE = "iPhone SE"
        case iPhoneLaterThan6s = "iPhone > 6s"
        case iPodTouch1G = "iPod Touch 1G"
        case iPodTouch2G = "iPod Touch 2G"
        case iPodTouch3G = "iPod Touch 3G"
        case iPodTouch4G = "iPod Touch 4G"
        case iPodTouch5G = "iPod Touch 5G"
        case iPodTouchLaterThan5G = "iPod Touch > 5G"
        case iPad = "iPad"
        case iPad2WiFi = "iPad 2 (WiFi)"
        case iPad2GSM = "iPad 2 (GSM)"
        case iPad2CDMA = "iPad 2 (CDMA)"
        //        case iPad2WiFiDuplicate = "iPad 2 (WiFi)"
        case iPadMiniWiFi = "iPad Mini (WiFi)"
        case iPadMiniGSM = "iPad Mini (GSM)"
        case iPadMiniGSMCDMA = "iPad Mini (GSM+CDMA)"
        case iPad3Wifi = "iPad 3 (WiFi)"
        case iPad3GSMCDMA = "iPad 3 (GSM+CDMA)"
        case iPad3GSM = "iPad 3 (GSM)"
        case iPad4Wifi = "iPad 4 (WiFi)"
        case iPad4GSM = "iPad 4 (GSM)"
        case iPad4GSMCDMA = "iPad 4 (GSM+CDMA)"
        case iPadAirWiFi = "iPad Air (WiFi)"
        case iPadAirCellular = "iPad Air (Cellular)"
        case iPadMini2GWiFi = "iPad mini 2G (WiFi)"
        case iPadMini2GCellular = "iPad mini 2G (Cellular)"
        case iPadLaterThanMini2G = "iPad > mini 2G"
        case simulator = "Simulator"
        case unknownDevice = "Unknown iOS device"
        
        init(model: String) {
            switch model {
            case "iPhone1,1": self = .iPhone1G
            case "iPhone1,2": self = .iPhone3G
            case "iPhone2,1": self = .iPhone3Gs
            case "iPhone3,1": self = .iPhone4
            case "iPhone3,3": self = .iPhone4Verizon
            case "iPhone4,1": self = .iPhone4s
            case "iPhone5,1": self = .iPhone5GSM
            case "iPhone5,2": self = .iPhone5GSMCDMA
            case "iPhone5,3": self = .iPhone5cGSM
            case "iPhone5,4": self = .iPhone5cGSMCDMA
            case "iPhone6,1": self = .iPhone5sGSM
            case "iPhone6,2": self = .iPhone5sGSMCDMA
            case "iPhone7,1": self = .iPhone6Plus
            case "iPhone7,2": self = .iPhone6
            case "iPhone8,1": self = .iPhone6sPlus
            case "iPhone8,2": self = .iPhone6s
            case "iPhone8,4": self = .iPhoneSE
            case "iPhone": self = .iPhoneLaterThan6s
            case "iPod1,1": self = .iPodTouch1G
            case "iPod2,1": self = .iPodTouch2G
            case "iPod3,1": self = .iPodTouch3G
            case "iPod4,1": self = .iPodTouch4G
            case "iPod5,1": self = .iPodTouch5G
            case "iPod": self = .iPodTouchLaterThan5G
            case "iPad1,1": self = .iPad
            case "iPad2,1": self = .iPad2WiFi
            case "iPad2,2": self = .iPad2GSM
            case "iPad2,3": self = .iPad2CDMA
            case "iPad2,4": self = .iPad2WiFi // NOTE DUPLICATE
            case "iPad2,5": self = .iPadMiniWiFi
            case "iPad2,6": self = .iPadMiniGSM
            case "iPad2,7": self = .iPadMiniGSMCDMA
            case "iPad3,1": self = .iPad3Wifi
            case "iPad3,2": self = .iPad3GSMCDMA
            case "iPad3,3": self = .iPad3GSM
            case "iPad3,4": self = .iPad4Wifi
            case "iPad3,5": self = .iPad4GSM
            case "iPad3,6": self = .iPad4GSMCDMA
            case "iPad4,1": self = .iPadAirWiFi
            case "iPad4,2": self = .iPadAirCellular
            case "iPad4,4": self = .iPadMini2GWiFi
            case "iPad4,5": self = .iPadMini2GCellular
            case "iPad": self = .iPadLaterThanMini2G
            case "i386": self = .simulator
            case "x86_64": self = .simulator
            default: self = .unknownDevice
            }
        }
    }
}
