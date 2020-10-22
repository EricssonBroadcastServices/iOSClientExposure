//
//  Downloads.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-10-16.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation


public struct Downloads: Codable {
    public let time: String?
    public let type: String?
    public let clientIp: String?
    public let deviceId: String?
    public let deviceType: String?
    public let deviceModelId: String?
    public let userId: String?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try container.decodeIfPresent(String.self, forKey: .time)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        clientIp = try container.decodeIfPresent(String.self, forKey: .clientIp)
        deviceId = try container.decodeIfPresent(String.self, forKey: .deviceId)
        deviceType = try container.decodeIfPresent(String.self, forKey: .deviceType)
        deviceModelId = try container.decodeIfPresent(String.self, forKey: .deviceModelId)
        userId = try container.decodeIfPresent(String.self, forKey: .userId)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case time
        case type
        case clientIp
        case deviceId
        case deviceType
        case deviceModelId
        case userId
        
    }
}
