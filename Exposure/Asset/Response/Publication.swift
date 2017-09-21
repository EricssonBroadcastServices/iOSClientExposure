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
        publicationDate = try? container.decode(String.self, forKey: .publicationDate)
        fromDate = try? container.decode(String.self, forKey: .fromDate)
        toDate = try? container.decode(String.self, forKey: .toDate)

        countries = try? container.decode([String].self, forKey: .countries)
        services = try? container.decode([String].self, forKey: .services)
        products = try? container.decode([String].self, forKey: .products)
        publicationId = try? container.decode(String.self, forKey: .publicationId)

        customData = try? container.decode([String: AnyJSONType].self, forKey: .customData)
        rights = try? container.decode(AssetRights.self, forKey: .rights)
        devices = try? container.decode([DeviceRights].self, forKey: .devices)
    }

    private enum CodingKeys: String, CodingKey {
        case publicationDate, fromDate, toDate, countries, services, products, publicationId
        case customData, rights, devices
    }
}
