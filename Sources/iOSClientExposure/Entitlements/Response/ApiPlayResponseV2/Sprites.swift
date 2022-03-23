//
//  Sprites.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2021-01-20.
//  Copyright © 2021 emp. All rights reserved.
//

import Foundation

/// Sprites in the entitlement/play request
public struct Sprites: Codable {
    public let width: Int?
    public let vtt: String?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        width = try container.decodeIfPresent(Int.self, forKey: .width)
        vtt = try container.decodeIfPresent(String.self, forKey: .vtt)
        
    }
    
    internal enum CodingKeys: String, CodingKey {
        case width
        case vtt
    }
}
