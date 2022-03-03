//
//  AdClips.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2021-06-18.
//  Copyright © 2021 emp. All rights reserved.
//

import Foundation

public struct AdClips: Codable {
    public let title: String?
    public let titleId: String?
    public let category: String?
    public let duration: Float?
    public let impressionUrlTemplates: [String]?
    public let videoClicks: VideoClicks?
    public let trackingEvents: AdTrackingEvents?
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        titleId = try container.decodeIfPresent(String.self, forKey: .titleId)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        duration = try container.decodeIfPresent(Float.self, forKey: .duration)
        impressionUrlTemplates = try container.decodeIfPresent([String].self, forKey: .impressionUrlTemplates)
        trackingEvents = try container.decodeIfPresent(AdTrackingEvents.self, forKey: .trackingEvents)
        videoClicks = try container.decodeIfPresent(VideoClicks.self, forKey: .videoClicks)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case title
        case titleId
        case category
        case duration
        case impressionUrlTemplates
        case trackingEvents
        case videoClicks
    }
    
}
