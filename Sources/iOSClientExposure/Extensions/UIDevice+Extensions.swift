//
//  UIDevice+Extensions.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-02-18.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    /// Extracts the *Exposure* formatted `DeviceType` from the current *device*
    @available(*, deprecated, message: "Use Device.type instead")
    public static func deviceType() -> DeviceType {
        return DeviceType(model: Device(name: nil).model)
    }
    
    /// Previous versions of *iOS* stated the system name as `iPhone OS`. This function merges legacy naming with the modern designation.
    public static var mergedSystemName: String {
        let systemName = UIDevice.current.systemName
        if systemName == "iPhone OS" { return "iOS" }
        return systemName
    }
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        if let path = Bundle.main.path(forResource: "AppleTVModels", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let name = dict[identifier] as? String {
            return name
        }
        
        return identifier
    }
    
    var appleTVModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "AppleTV1,1": return "atv-1"
        case "AppleTV2,1": return "atv-2"
        case "AppleTV3,1", "AppleTV3,2", "AppleTV3,3": return "atv-3"
        case "AppleTV5,3": return "atv-4"
        case "AppleTV6,2": return "atv-4k-1"
        case "AppleTV11,1": return "atv-4k-2"
        case "AppleTV11,2", "AppleTV11,3": return "atv-4k-3"
        default: return "atv-unknown"
        }
    }
    
    /* var appleTVModelNumber: String? {
        guard self.userInterfaceIdiom == .tv else { return nil }
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "AppleTV1,1": return "A1218"
        case "AppleTV2,1": return "A1378"
        case "AppleTV3,1", "AppleTV3,2": return "A1427"
        case "AppleTV3,3": return "A1469"
        case "AppleTV5,3": return "A1625"
        case "AppleTV6,2": return "A1842"
        case "AppleTV6,2": return "A1844"
        case "AppleTV11,1": return "A2169"
        case "AppleTV11,2", "AppleTV11,3": return "A2843"
        default: return "UNKNOWN"
        }
    } */
    
    var appleTVAIdentifier: String? {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        let prefix = "AppleTV"
        guard identifier.hasPrefix(prefix) else { return nil }
        
        let aNumber = identifier.replacingOccurrences(of: prefix, with: "")
        return "A" + aNumber
    }
}
