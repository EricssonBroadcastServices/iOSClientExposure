//
//  Airing.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-07.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

///
public struct Airing: Decodable {
    /// Id
    public let id: String?
    
    /// External Id
    public let externalId: String?
    
    /// Is this catchup
    public let catchup: Bool?
    
    /// Ids for different airings of this program
    public let programs: [String]?

}
