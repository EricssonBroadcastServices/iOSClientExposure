//
//  LinkedEntity.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct LinkedEntity: Decodable {
    public let entityId: String?
    public let linkType: String?
    public let entityType: String?
}
