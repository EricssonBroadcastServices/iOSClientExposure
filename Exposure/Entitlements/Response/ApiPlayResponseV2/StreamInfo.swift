//
//  StreamInfo.swift
//  Exposure-iOS
//
//  Created by Udaya Sri Senarathne on 2019-04-08.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation

public struct StreamInfo:Codable {
    public let channelId: String?
    public let end: Int?
    public let staticProgram: Bool?
    public let live: Bool?
    public let event: Bool?
    public let programId: String?
    public let start: Int?
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        channelId = try container.decodeIfPresent(String.self, forKey: .channelId)
        end = try container.decodeIfPresent(Int.self, forKey: .end)
        staticProgram = try container.decodeIfPresent(Bool.self, forKey: .staticProgram)
        live = try container.decodeIfPresent(Bool.self, forKey: .live)
        event = try container.decodeIfPresent(Bool.self, forKey: .event)
        programId = try container.decodeIfPresent(String.self, forKey: .programId)
        start = try container.decodeIfPresent(Int.self, forKey: .start)
        
    }
    
    internal enum CodingKeys: String, CodingKey {
        case channelId
        case end
        case staticProgram = "static"
        case live
        case event
        case programId
        case start
    }
}
