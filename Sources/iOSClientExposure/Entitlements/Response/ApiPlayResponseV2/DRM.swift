//
//  DRM.swift
//  Exposure-iOS
//
//  Created by Udaya Sri Senarathne on 2019-04-08.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation

public struct FairPlay: Codable {
    
    public let certificateUrl: String?
    public let licenseServerUrl: String?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        certificateUrl = try container.decodeIfPresent(String.self, forKey: .certificateUrl)
        licenseServerUrl = try container.decodeIfPresent(String.self, forKey: .licenseServerUrl)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case certificateUrl
        case licenseServerUrl
    }
}
