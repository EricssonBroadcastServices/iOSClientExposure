//
//  DeviceInfo.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

extension UIDevice {
    /// Extracts the *Exposure* formatted `DeviceType` from the current *device*
    public static func deviceType() -> DeviceType {
        return DeviceType(model: current.model)
    }
    
    /// Previous versions of *iOS* stated the system name as `iPhone OS`. This function merges legacy naming with the modern designation.
    internal static var mergedSystemName: String {
        let systemName = UIDevice.current.systemName
        if systemName == "iPhone OS" { return "iOS" }
        return systemName
    }
}
public struct DeviceInfo {
    public init(device: Device = Device()) {
        self.device = device
    }
    
    /// Unique device identifier
    public var deviceId: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    /// Device specific information
    public let device: Device
    
    public struct Device {
        public init(name: String? = nil) {
            self.name = name
        }
        
        /// Height of the screen in `points`
        public var height: Int {
            return Int(UIScreen.main.bounds.size.height)
        }
        
        /// Width of the screen in `points`
        public var width: Int {
            return Int(UIScreen.main.bounds.size.width)
        }
        
        /// Device model as reported in Apple's internal formatting
        ///
        /// Examples include:
        /// * `iPhone7,1` - iPhone6 Plus
        /// * `iPhone7,2` - iPhone6
        public var model: String {
            var size = 0
            sysctlbyname("hw.machine", nil, &size, nil, 0)
            var machine = [CChar](repeating: 0,  count: Int(size))
            sysctlbyname("hw.machine", &machine, &size, nil, 0)
            return String(cString: machine)
        }
        
        /// Device name
        public let name: String?
        
        /// OS name reported by merging legacy system names with more modern ones.
        public var os: String {
            return UIDevice.mergedSystemName
        }
        
        /// Raw os version.
        public var osVersion: String {
            return UIDevice.current.systemVersion
        }
        
        /// So far, only Apple manufactures for the Apple echo system
        public let manufacturer: String = "Apple"
        
        /// `DeviceType` reported in a format expected by *Exposure*
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
    
    /// Keys used to specify `json` body for the request.
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
            JSONKeys.osVersion.rawValue: osVersion,
            JSONKeys.manufacturer.rawValue: manufacturer,
            JSONKeys.type.rawValue: type.queryParam
        ]
        
        if let name = name { json[JSONKeys.name.rawValue] = name }
        
        return json
    }
    
    /// Keys used to specify `json` body for the request.
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
