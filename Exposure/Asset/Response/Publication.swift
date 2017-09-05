//
//  Publication.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Publication {
    
    public let publicationDate: String?
    public let fromDate: String?
    public let toDate: String?
    
    public let countries: [String]?
    public let services: [String]?
    public let products: [String]?
    public let publicationId: String?
    
    public let customData: [String: Any]? // JsonNode
    public let rights: AssetRights?
    public let devices: [DeviceRights]?
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        publicationDate = actualJson[JSONKeys.publicationDate.rawValue].string
        fromDate = actualJson[JSONKeys.fromDate.rawValue].string
        toDate = actualJson[JSONKeys.toDate.rawValue].string
        
        countries = actualJson[JSONKeys.countries.rawValue].array?.flatMap{ $0.string }
        services = actualJson[JSONKeys.services.rawValue].array?.flatMap{ $0.string }
        products = actualJson[JSONKeys.products.rawValue].array?.flatMap{ $0.string }
        publicationId = actualJson[JSONKeys.publicationId.rawValue].string
        
        customData = actualJson[JSONKeys.customData.rawValue].dictionaryObject
        rights = AssetRights(json: actualJson[JSONKeys.rights.rawValue].object)
        devices = actualJson[JSONKeys.devices.rawValue].arrayObject?.flatMap{ DeviceRights(json: $0) }
        
        if publicationDate == nil && fromDate == nil && toDate == nil
            && countries == nil && services == nil && products == nil && publicationId == nil
            && customData == nil && rights == nil && devices == nil {
            return nil
        }
    }
    
    internal enum JSONKeys: String {
        case publicationDate = "publicationDate"
        case fromDate = "fromDate"
        case toDate = "toDate"
        case countries = "countries"
        case services = "services"
        case products = "products"
        case publicationId = "publicationId"
        case customData = "customData"
        case rights = "rights"
        case devices = "devices"
    }
}
