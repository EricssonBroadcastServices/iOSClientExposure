//
//  Airing.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-07.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

///
public struct Airing: ExposureConvertible {
    /// Id
    public let id: String?
    
    /// External Id
    public let externalId: String?
    
    /// Is this catchup
    public let catchup: Bool?
    
    /// Ids for different airings of this program
    public let programs: [String]?
    
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        
        id = actualJson[JSONKeys.id.rawValue].string
        externalId = actualJson[JSONKeys.externalId.rawValue].string
        catchup = actualJson[JSONKeys.catchup.rawValue].bool
        programs = actualJson[JSONKeys.programs.rawValue].array?.flatMap{ $0[JSONKeys.programId.rawValue].string }
        
        if (id == nil && externalId == nil && catchup == nil && programs == nil) {
            return nil
        }
    }
    
    internal enum JSONKeys: String {
        case id = "id"
        case externalId = "externalId"
        case catchup = "catchup"
        case programs = "programs"
        case programId = "programId"
    }
}
