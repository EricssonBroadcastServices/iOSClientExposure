//
//  MarkerPoints.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2021-09-06.
//  Copyright © 2021 emp. All rights reserved.
//

import Foundation

/// Player Cue points : INTRO / POINT / CHAPTER  / CREDITS etc
public struct MarkerPoint: Codable {
    public var type: String?
    public var offset: Int?
    public var endOffset: Int?
    public var localized: [LocalizedData]?
    
    
    public init(type: String? , offset: Int? , endOffset: Int? , localized: [LocalizedData]? = nil ) {
        self.type = type
        self.offset = offset
        self.endOffset = endOffset
        self.localized = localized
        
    }
    
    internal enum CodingKeys: String, CodingKey {
        case type
        case offset
        case endOffset
        case localized
    }
}

