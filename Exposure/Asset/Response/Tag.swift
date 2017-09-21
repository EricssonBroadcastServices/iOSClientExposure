//
//  Tag.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Tag: Decodable {
    public let created: String?
    public let changed: String?
    public let type: String?
    public let tagValues: [Values]?
    
    public struct Values: Decodable {
        public let tagId: String?
    }
}
