//
//  DeleteDownloadResponse.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-10-19.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation

public struct DeleteDownloadCompleted: Codable {
    public let message: String?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        
    }
    
    internal enum CodingKeys: String, CodingKey {
        case message
    }
}
