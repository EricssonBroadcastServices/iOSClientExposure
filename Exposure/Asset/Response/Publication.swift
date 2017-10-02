//
//  Publication.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Publication: Decodable {
    
    public let publicationDate: String?
    public let fromDate: String?
    public let toDate: String?
    
    public let countries: [String]?
    public let services: [String]?
    public let products: [String]?
    public let publicationId: String?
    
    public let customData: [String: AnyJSONType]? // JsonNode
    public let rights: AssetRights?
    public let devices: [DeviceRights]?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        publicationDate = try container.decodeIfPresent(String.self, forKey: .publicationDate)
        fromDate = try container.decodeIfPresent(String.self, forKey: .fromDate)
        toDate = try container.decodeIfPresent(String.self, forKey: .toDate)

        countries = try container.decodeIfPresent([String].self, forKey: .countries)
        services = try container.decodeIfPresent([String].self, forKey: .services)
        products = try container.decodeIfPresent([String].self, forKey: .products)
        publicationId = try container.decodeIfPresent(String.self, forKey: .publicationId)

        customData = try container.decodeIfPresent([String: AnyJSONType].self, forKey: .customData)
        rights = try container.decodeIfPresent(AssetRights.self, forKey: .rights)
        devices = try container.decodeIfPresent([DeviceRights].self, forKey: .devices)
    }

    private enum CodingKeys: String, CodingKey {
        case publicationDate, fromDate, toDate, countries, services, products, publicationId
        case customData, rights, devices
    }
}
