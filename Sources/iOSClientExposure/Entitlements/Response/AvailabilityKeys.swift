//
//  AvailabilityKeys.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-07-22.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

public struct AvailabilityKeys: Decodable {
    public let expiryDate: String?
    public let availabilityKeys: [String]?
    
    public init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           expiryDate = try container.decodeIfPresent(String.self, forKey: .expiryDate)
           availabilityKeys = try container.decodeIfPresent([String].self, forKey: .availabilityKeys)
       }
       
       internal enum CodingKeys: String, CodingKey {
           case expiryDate
           case availabilityKeys
       }
}

