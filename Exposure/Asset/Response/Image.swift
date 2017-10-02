//
//  Image.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Image: Decodable {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        height = try container.decodeIfPresent(Int.self, forKey: .height)
        width = try container.decodeIfPresent(Int.self, forKey: .width)
        orientation = Orientation(string: try container.decodeIfPresent(String.self, forKey: .orientation))
        type = try container.decodeIfPresent(String.self, forKey: .type)
    }

    internal enum CodingKeys: String, CodingKey {
        case url, height, width, orientation, type
    }
    
    public enum Orientation: Equatable {
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
        
        public static func == (lhs: Orientation, rhs: Orientation) -> Bool {
            switch (lhs, rhs) {
            case (.portrait, .portrait): return true
            case (.landscape, .landscape): return true
            case (.square, .square): return true
            case (.unknown, .unknown): return true
            case (.other(let l), .other(let r)): return l == r
            default: return false
            }
        }
    }
}
