//
//  ContractRestrictions.swift
//  Exposure-iOS
//
//  Created by Udaya Sri Senarathne on 2019-04-08.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation

public struct ContractRestrictions: Codable {
    
    public let airplayEnabled: Bool?
    
    public let ffEnabled: Bool?
    
    public let maxBitrate: Int64?
    
    public let maxResHeight: Int?
    
    public let minBitrate: Int64?
    
    public let rwEnabled: Bool?
    
    public let timeshiftEnabled: Bool?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        airplayEnabled = try container.decodeIfPresent(Bool.self, forKey: .airplayEnabled)
        ffEnabled = try container.decodeIfPresent(Bool.self, forKey: .ffEnabled)
        maxBitrate = try container.decodeIfPresent(Int64.self, forKey: .maxBitrate)
        maxResHeight = try container.decodeIfPresent(Int.self, forKey: .maxResHeight)
        minBitrate = try container.decodeIfPresent(Int64.self, forKey: .minBitrate)
        rwEnabled = try container.decodeIfPresent(Bool.self, forKey: .rwEnabled)
        timeshiftEnabled = try container.decodeIfPresent(Bool.self, forKey: .timeshiftEnabled)
        
    }
    
    internal enum CodingKeys: String, CodingKey {
        case airplayEnabled
        case ffEnabled
        case maxBitrate
        case maxResHeight
        case minBitrate
        case rwEnabled
        case timeshiftEnabled
    }
}

