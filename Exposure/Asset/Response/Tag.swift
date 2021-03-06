//
//  Tag.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Tag: Codable {
    public let created: String?
    public let changed: String?
    public let type: String?
    public let tagValues: [Values]?
    
    public struct Values: Codable {
        public let tagId: String?
    }
}
