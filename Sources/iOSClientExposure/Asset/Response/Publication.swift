//
//  Publication.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Publication: Codable {
    
    public let publicationDate: String?
    public let fromDate: String?
    public let toDate: String?
    
    public let countries: [String]?
    public let services: [String]?
    public let products: [String]?
    public let availabilityKeys: [String]?
    public let publicationId: String?
    
    public let customData: [String: AnyJSONType]? // JsonNode
    public let rights: AssetRights?
    public let devices: [DeviceRights]?

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(publicationDate, forKey: .publicationDate)
        try container.encodeIfPresent(fromDate, forKey: .fromDate)
        try container.encodeIfPresent(toDate, forKey: .toDate)
        
        try container.encodeIfPresent(countries, forKey: .countries)
        try container.encodeIfPresent(services, forKey: .services)
        try container.encodeIfPresent(products, forKey: .products)
        try container.encodeIfPresent(publicationId, forKey: .publicationId)
        
        try container.encodeIfPresent(customData, forKey: .customData)
        try container.encodeIfPresent(rights, forKey: .rights)
        try container.encodeIfPresent(devices, forKey: .devices)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        publicationDate = try container.decodeIfPresent(String.self, forKey: .publicationDate)
        fromDate = try container.decodeIfPresent(String.self, forKey: .fromDate)
        toDate = try container.decodeIfPresent(String.self, forKey: .toDate)

        countries = try container.decodeIfPresent([String].self, forKey: .countries)
        services = try container.decodeIfPresent([String].self, forKey: .services)
        products = try container.decodeIfPresent([String].self, forKey: .products)
        availabilityKeys = try container.decodeIfPresent([String].self, forKey: .availabilityKeys)
        publicationId = try container.decodeIfPresent(String.self, forKey: .publicationId)

        customData = try container.decodeIfPresent([String: AnyJSONType].self, forKey: .customData)
        rights = try container.decodeIfPresent(AssetRights.self, forKey: .rights)
        devices = try container.decodeIfPresent([DeviceRights].self, forKey: .devices)
    }

    private enum CodingKeys: String, CodingKey {
        case publicationDate, fromDate, toDate, countries, services, products, availabilityKeys, publicationId
        case customData, rights, devices
    }
}
