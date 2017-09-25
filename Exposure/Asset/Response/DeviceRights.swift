//
//  DeviceRight.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct DeviceRights: Decodable {
    /// Device type this rights concerns
    public let type: DeviceType?
    
    public let model: String?
    public let manufacturer: String?
    public let os: String?
    public let osVersion: String?
    
    /// Asset rights specific for this device
    public let rights: AssetRights?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = DeviceType(string: try container.decodeIfPresent(String.self, forKey: .type))
        model = try container.decodeIfPresent(String.self, forKey: .model)
        manufacturer = try container.decodeIfPresent(String.self, forKey: .manufacturer)
        os = try container.decodeIfPresent(String.self, forKey: .os)
        osVersion = try container.decodeIfPresent(String.self, forKey: .osVersion)
        rights = try container.decodeIfPresent(AssetRights.self.self, forKey: .rights)
    }

    enum CodingKeys: String, CodingKey {
        case type, model, manufacturer, os, osVersion, rights
    }
}
