//
//  BooksMarks.swift
//  Exposure-iOS
//
//  Created by Udaya Sri Senarathne on 2019-04-08.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation

public struct BooksMarks: Codable {
    
    public let lastViewedOffset: Int?
    public let liveTime: Int64?
    public let lastViewedTime: Int64?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lastViewedOffset = try container.decodeIfPresent(Int.self, forKey: .lastViewedOffset)
        liveTime = try container.decodeIfPresent(Int64.self, forKey: .liveTime)
        lastViewedTime = try container.decodeIfPresent(Int64.self, forKey: .lastViewedTime)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case lastViewedOffset
        case liveTime
        case lastViewedTime
    }
    
}
