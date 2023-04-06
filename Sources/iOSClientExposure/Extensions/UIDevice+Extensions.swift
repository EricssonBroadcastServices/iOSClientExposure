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
    
    
    /// Return apple device model in formatted way : ex - appletv-11-1 , iphone-12-5 etc
    var appleDeviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        // convert identifier to lowercase : ex  iphone12,5 / appletv11,1
        let lowercaseIdentifier = identifier.lowercased()
        
        // get the alphabetic character set : iphone / appletv
        let deviceType = lowercaseIdentifier.trimmingCharacters(in: CharacterSet.letters.inverted )
        
        // get the apple's device identifier : 12,5 / 11,1
        var deviceIdentifier = lowercaseIdentifier.trimmingCharacters(in: CharacterSet.letters )
        
        // replace the `,` with `-`
        deviceIdentifier = deviceIdentifier.replacingOccurrences(of: ",", with: "-").lowercased()
        return "\(deviceType)-\(deviceIdentifier)"
    }

}
