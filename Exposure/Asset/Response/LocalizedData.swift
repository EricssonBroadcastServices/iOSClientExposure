//
//  LocalizedData.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct LocalizedData {
    public let locale: String?
    public let title: String?
    public let sortingTitle: String?
    public let description: String?
    public let tinyDescription: String?
    public let shortDescription: String?
    public let longDescription: String?
    public let images: [Image]?
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        locale = actualJson[JSONKeys.locale.rawValue].string
        title = actualJson[JSONKeys.title.rawValue].string
        sortingTitle = actualJson[JSONKeys.sortingTitle.rawValue].string
        description = actualJson[JSONKeys.description.rawValue].string
        tinyDescription = actualJson[JSONKeys.tinyDescription.rawValue].string
        shortDescription = actualJson[JSONKeys.shortDescription.rawValue].string
        longDescription = actualJson[JSONKeys.longDescription.rawValue].string
        
        images = actualJson[JSONKeys.images.rawValue].arrayObject?.flatMap{ Image(json: $0) }
        
        if locale == nil && title == nil && sortingTitle == nil && description == nil
            && tinyDescription == nil && shortDescription == nil && longDescription == nil && images == nil { return nil }
    }
    
    internal enum JSONKeys: String {
        case locale = "locale"
        case title = "title"
        case sortingTitle = "sortingTitle"
        case description = "description"
        case tinyDescription = "tinyDescription"
        case shortDescription = "shortDescription"
        case longDescription = "longDescription"
        case images = "images"
    }
}
