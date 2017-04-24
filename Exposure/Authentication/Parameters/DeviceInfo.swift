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
        
        public var model: String {
            var size = 0
            sysctlbyname("hw.machine", nil, &size, nil, 0)
            var machine = [CChar](repeating: 0,  count: Int(size))
            sysctlbyname("hw.machine", &machine, &size, nil, 0)
            return String(cString: machine)
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
            JSONKeys.model.rawValue: model,
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
