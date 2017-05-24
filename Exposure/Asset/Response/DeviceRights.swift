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
    public enum DeviceRightsType {
        case web
        case mobile
        case tablet
        case appleTv
        case smartTv
        case console
        case stb
        case other(string: String)
        
        internal init?(string: String?) {
            guard let value = string else { return nil }
            self = DeviceRightsType(string: value)
        }
        
        internal init(string: String) {
            switch string {
            case "WEB": self = .web
            case "MOBILE": self = .mobile
            case "TABLET": self = .tablet
            case "APPLE_TV": self = .appleTv
            case "SMART_TV": self = .smartTv
            case "CONSOLE": self = .console
            case "STB": self = .stb
            default: self = .other(string: string)
            }
        }
    }
    
    public let type: DeviceRightsType?
    public let model: String?
    public let manufacturer: String?
    public let os: String?
    public let osVersion: String?
    public let rights: AssetRights?
    
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        type = DeviceRightsType(string: actualJson[JSONKeys.type.rawValue].string)
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
