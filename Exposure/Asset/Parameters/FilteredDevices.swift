//
//  FilteredDevices.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Defines an *Exposure request* filter returning assets allowed for the specified `DeviceType`.
public protocol FilteredDevices {
    /// Filter to apply
    var deviceFilter: DeviceFilter { get set }
}

extension FilteredDevices {
    /// `DeviceType` to filter on, or nil
    public var deviceIncluded: DeviceType? {
        return deviceFilter.deviceType
    }
    
    /// Only return assets allowed for playback on `deviceType`
    ///
    /// - parameter deviceType: device to filter on
    /// - returns: `Self`
    public func filter(on deviceType: DeviceType?) -> Self {
        var old = self
        old.deviceFilter = DeviceFilter(deviceType: deviceType)
        return old
    }
}

/// Used internally to configure the device filter
public struct DeviceFilter {
    /// `DeviceType` to filter on
    internal let deviceType: DeviceType?
    
    internal init(deviceType: DeviceType? = nil) {
        self.deviceType = deviceType
    }
}
