//
//  DeviceRight.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct DeviceRights {
    /// Device type this rights concerns
    public let type: DeviceType?
    
    public let model: String?
    public let manufacturer: String?
    public let os: String?
    public let osVersion: String?
    
    /// Asset rights specific for this device
    public let rights: AssetRights?
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        type = DeviceType(string: actualJson[JSONKeys.type.rawValue].string)
        model = actualJson[JSONKeys.model.rawValue].string
        manufacturer = actualJson[JSONKeys.manufacturer.rawValue].string
        os = actualJson[JSONKeys.os.rawValue].string
        osVersion = actualJson[JSONKeys.osVersion.rawValue].string
        
        rights = AssetRights(json: actualJson[JSONKeys.rights.rawValue].object)
        
        if type == nil && model == nil && manufacturer == nil
            && os == nil && osVersion == nil && rights == nil { return nil }
    }
    
    internal enum JSONKeys: String {
        case type = "type"
        case model = "model"
        case manufacturer = "manufacturer"
        case os = "os"
        case osVersion = "osVersion"
        case rights = "rights"
    }
}
