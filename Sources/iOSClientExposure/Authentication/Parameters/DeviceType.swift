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
    case airplay
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
        case "airplay": self = .airplay
        default: self = .other(string: string)
        }
    }
    
    /// Initializer for creating `DeviceType`s used for the joint `iOS`/`tvOS` platform.
    ///
    /// - note: Default value if no matches found equals to `.mobile`
    ///
    /// - parameter model: *System* description of the current device.
    internal init(model: String) {
        let lcModel = model.lowercased()
        if lcModel.contains("iPhone".lowercased()) {
            self = .mobile
        }
        else if lcModel.contains("iPad".lowercased()) {
            self = .tablet
        }
        else if lcModel.contains("AppleTV".lowercased()) {
            self = .appleTv
        }
        else if lcModel.contains("x86_64".lowercased()) {
            self = .mobile
        }
        else {
            self = .other(string: model)
        }
    }
    
    /// Keys used to specify `DeviceType` as a query parameter for the request. ( mainly used for `/login` & analytics )
    internal var queryParam: String {
        switch self {
        case .mobile: return "MOBILE"
        case .tablet: return "TABLET"
        case .appleTv: return "APPLE_TV"
        case .airplay: return "airplay"
        case .other(string: let value): return value
        }
    }
    
    
    /// Keys used to specify `DeviceType` as a query parameter for the `/play` request when using SSAI
    internal var deviceTypeForPlay: String {
        switch self {
        case .mobile: return "mobile"
        case .tablet: return "tablet"
        case .appleTv: return "ctv"
        case .airplay: return "airplay"
        case .other(string: let value): return value
        }
    }
}
