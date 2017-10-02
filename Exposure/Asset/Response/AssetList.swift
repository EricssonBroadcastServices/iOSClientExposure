//
//  AssetList.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-17.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct AssetList: Decodable {
    public let totalCount: Int?
    public let pageSize: Int?
    public let pageNumber: Int?
    public let items: [Asset]?
}
