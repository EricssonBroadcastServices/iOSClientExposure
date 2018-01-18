//
//  DeviceType.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Exposure* defines a set of *device types*.
public enum DeviceType {
    case mobile
    case tablet
    case appleTv
    case other(string: String)
    
    internal init?(string: String?) {
        guard let value = string else { return nil }
        self = DeviceType(string: value)
    }
    
    internal init(string: String) {
        switch string {
        case "MOBILE": self = .mobile
        case "TABLET": self = .tablet
        case "APPLE_TV": self = .appleTv
        default: self = .other(string: string)
        }
    }
    
    /// Initializer for creating `DeviceType`s used for the joint `iOS`/`tvOS` platform.
    ///
    /// - note: Default value if no matches found equals to `.mobile`
    ///
    /// - parameter model: *System* description of the current device.
    internal init(model: String) {
        switch model {
        case "iPhone": self = .mobile
        case "iPad": self = .tablet
        case "AppleTv": self = .appleTv
        default: self = .mobile
        }
    }
    
    /// Keys used to specify `DeviceType` as a query parameter for the request.
    internal var queryParam: String {
        switch self {
        case .mobile: return "MOBILE"
        case .tablet: return "TABLET"
        case .appleTv: return "APPLE_TV"
        case .other(string: let value): return value
        }
    }
}
