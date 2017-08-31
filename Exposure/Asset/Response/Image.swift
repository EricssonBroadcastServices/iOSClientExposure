//
//  Image.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Image {
    /// Path to where the image is located
    public let url: String?
    
    /// Height of the image
    public let height: Int?
    
    /// Width of the image
    public let width: Int?
    
    /// Orientation of the image
    public let orientation: Orientation?
    
    /// Image type
    public let type: String?
    
    public init?(json: Any) {
        let actualJson = JSON(json)
        url = actualJson[JSONKeys.url.rawValue].string
        height = actualJson[JSONKeys.height.rawValue].int
        width = actualJson[JSONKeys.width.rawValue].int
        orientation = Orientation(string: actualJson[JSONKeys.orientation.rawValue].string)
        type = actualJson[JSONKeys.type.rawValue].string
        
        if url == nil && height == nil && width == nil && orientation == nil && type == nil { return nil }
    }
    
    internal enum JSONKeys: String {
        case url = "url"
        case height = "height"
        case width = "width"
        case orientation = "orientation"
        case type = "type"
    }
    
    public enum Orientation {
        case portrait
        case landscape
        case square
        case unknown
        case other(type: String)
        
        internal init?(string: String?) {
            guard let value = string else { return nil }
            self = Orientation(string: value)
        }
        
        internal init(string: String) {
            switch string {
            case "PORTRAIT": self = .portrait
            case "LANDSCAPE": self = .landscape
            case "SQUARE": self = .square
            case "UNKNOWN": self = .unknown
            default: self = .other(type: string)
            }
        }
    }
}
