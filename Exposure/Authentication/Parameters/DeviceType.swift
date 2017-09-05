//
//  DeviceType.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Exposure* defines a set of *device types*. For the joint `iOS`/`tvOS` platform only a handful of them are relevant. All of them are included here for completeness sake but this is subject to change.
public enum DeviceType {
    case web
    case mobile
    case tablet
    case appleTv
    case smartTv
    case console
    case stb
    case other(string: String)
    
    internal init?(string: String?) {
        guard let value = string else { return nil }
        self = DeviceType(string: value)
    }
    
    internal init(string: String) {
        switch string {
        case "WEB": self = .web
        case "MOBILE": self = .mobile
        case "TABLET": self = .tablet
        case "APPLE_TV": self = .appleTv
        case "SMART_TV": self = .smartTv
        case "CONSOLE": self = .console
        case "STB": self = .stb
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
        case .web: return "WEB"
        case .mobile: return "MOBILE"
        case .tablet: return "TABLET"
        case .appleTv: return "APPLE_TV"
        case .smartTv: return "SMART_TV"
        case .console: return "CONSOLE"
        case .stb: return "STB"
        case .other(string: let value): return value
        }
    }
}
