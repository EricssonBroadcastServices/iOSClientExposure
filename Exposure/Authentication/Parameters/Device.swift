//
//  Device.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-02-18.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation
public struct Device: Encodable {
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
        return DeviceType(model: model)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(height, forKey: .height)
        try container.encode(width, forKey: .width)
        try container.encode(model, forKey: .model)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(os, forKey: .os)
        try container.encode(osVersion, forKey: .osVersion)
        try container.encode(manufacturer, forKey: .manufacturer)
        try container.encode(type.queryParam, forKey: .type)
    }
    
    /// Keys used to specify `json` body for the request.
    internal enum CodingKeys: String, CodingKey {
        case height
        case width
        case model
        case name
        case os
        case osVersion
        case manufacturer
        case type
    }
}
