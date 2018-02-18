//
//  UIDevice+Extensions.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-02-18.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

extension UIDevice {
    /// Extracts the *Exposure* formatted `DeviceType` from the current *device*
    public static func deviceType() -> DeviceType {
        return DeviceType(model: current.model)
    }
    
    /// Previous versions of *iOS* stated the system name as `iPhone OS`. This function merges legacy naming with the modern designation.
    public static var mergedSystemName: String {
        let systemName = UIDevice.current.systemName
        if systemName == "iPhone OS" { return "iOS" }
        return systemName
    }
}
