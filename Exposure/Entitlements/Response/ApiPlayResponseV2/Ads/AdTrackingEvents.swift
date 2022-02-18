//
//  AdTrackingEvents.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2021-06-18.
//  Copyright © 2021 emp. All rights reserved.
//

import Foundation

public struct AdTrackingEvents: Codable {
    
    public let start: [String]?
    public let load: [String]?
    public let complete: [String]?
    public let firstQuartile: [String]?
    public let midpoint: [String]?
    public let thirdQuartile: [String]?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        load = try container.decodeIfPresent([String].self, forKey: .load)
        start = try container.decodeIfPresent([String].self, forKey: .start)
        firstQuartile = try container.decodeIfPresent([String].self, forKey: .firstQuartile)
        midpoint = try container.decodeIfPresent([String].self, forKey: .midpoint)
        thirdQuartile = try container.decodeIfPresent([String].self, forKey: .thirdQuartile)
        complete = try container.decodeIfPresent([String].self, forKey: .complete)
      
        
    }
    
    internal enum CodingKeys: String, CodingKey {
        case load
        case start
        case complete
        case firstQuartile
        case midpoint
        case thirdQuartile
    }
}
