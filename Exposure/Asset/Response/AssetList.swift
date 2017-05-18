//
//  AssetList.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-17.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct AssetList: ExposureConvertible {
    public let totalCount: Int?
    public let pageSize: Int?
    public let pageNumber: Int?
    public let items: [Asset]?
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        
        totalCount = actualJson[JSONKeys.totalCount.rawValue].int
        pageSize = actualJson[JSONKeys.pageSize.rawValue].int
        pageNumber = actualJson[JSONKeys.pageNumber.rawValue].int
        items = actualJson[JSONKeys.items.rawValue].arrayObject?.flatMap{ Asset(json: $0) }
        
        if totalCount == nil && pageSize == nil && pageNumber == nil && items == nil { return nil }
    }
    
    internal enum JSONKeys: String {
        case totalCount = "totalCount"
        case pageSize = "pageSize"
        case pageNumber = "pageNumber"
        case items = "items"
    }
}
