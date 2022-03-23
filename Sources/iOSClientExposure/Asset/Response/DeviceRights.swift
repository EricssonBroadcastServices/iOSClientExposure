//
//  DeviceRight.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct DeviceRights: Codable {
    /// Device type this rights concerns
    public let type: DeviceType?
    
    public let model: String?
    public let manufacturer: String?
    public let os: String?
    public let osVersion: String?
    
    /// Asset rights specific for this device
    public let rights: AssetRights?

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(type?.queryParam, forKey: .type)
        try container.encodeIfPresent(model, forKey: .model)
        try container.encodeIfPresent(manufacturer, forKey: .manufacturer)
        try container.encodeIfPresent(os, forKey: .os)
        try container.encodeIfPresent(osVersion, forKey: .osVersion)
        try container.encodeIfPresent(rights, forKey: .rights)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = DeviceType(string: try container.decodeIfPresent(String.self, forKey: .type))
        model = try container.decodeIfPresent(String.self, forKey: .model)
        manufacturer = try container.decodeIfPresent(String.self, forKey: .manufacturer)
        os = try container.decodeIfPresent(String.self, forKey: .os)
        osVersion = try container.decodeIfPresent(String.self, forKey: .osVersion)
        rights = try container.decodeIfPresent(AssetRights.self, forKey: .rights)
    }

    enum CodingKeys: String, CodingKey {
        case type, model, manufacturer, os, osVersion, rights
    }
}
