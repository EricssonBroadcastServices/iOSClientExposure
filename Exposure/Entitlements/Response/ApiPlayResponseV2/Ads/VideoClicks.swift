//
//  VideoClicks.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2022-02-14.
//  Copyright © 2022 emp. All rights reserved.
//

import Foundation



/// Click through data : Enables users to click the url & navigate to the url related to the Ad
public struct VideoClicks: Codable {
    
    /// url to browse to : Ad url
    public let clickThroughUrl: String?
    
    /// Url's to track : send to anlytics
    public let clickTrackingUrls: [String]?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clickThroughUrl = try container.decodeIfPresent(String.self, forKey: .clickThroughUrl)
        clickTrackingUrls = try container.decodeIfPresent([String].self, forKey: .clickTrackingUrls)
    
    }
    
    internal enum CodingKeys: String, CodingKey {
        case clickThroughUrl
        case clickTrackingUrls
    }
    
}
