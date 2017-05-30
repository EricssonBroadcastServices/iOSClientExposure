//
//  FilteredDevices.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public protocol FilteredDevices {
    var deviceFilter: DeviceFilter { get set }
}

extension FilteredDevices {
    // MARK: Published
    public var deviceIncluded: DeviceType? {
        return deviceFilter.deviceType
    }
    
    public func filter(on deviceType: DeviceType?) -> Self {
        var old = self
        old.deviceFilter = DeviceFilter(deviceType: deviceType)
        return old
    }
}

public struct DeviceFilter {
    internal let deviceType: DeviceType?
    
    internal init(deviceType: DeviceType? = nil) {
        self.deviceType = deviceType
    }
}
