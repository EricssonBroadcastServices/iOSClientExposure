//
//  EntitlementValidation.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Response detailing the result of an `EntitlementValidation` request.
///
/// Will return 200 even if user is not entitled with the result being in the `status` message.
public struct EntitlementValidation: Decodable {

    public let accountId: String?
    
    public let requestId: String?

    public let productId: String?
    
    public let publicationId: String?
    
    public let streamInfo: StreamInfo?
    
    public let status: String?
    
}

extension EntitlementValidation {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        accountId = try container.decodeIfPresent(String.self, forKey: .accountId)
        requestId = try container.decodeIfPresent(String.self, forKey: .requestId)
        productId = try container.decodeIfPresent(String.self, forKey: .productId)
        publicationId = try container.decodeIfPresent(String.self, forKey: .publicationId)
        streamInfo = try container.decodeIfPresent(StreamInfo.self, forKey: .streamInfo)
        status = try container.decodeIfPresent(String.self, forKey: .status)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case accountId
        case requestId
        case productId
        case publicationId
        case streamInfo
        case status
    }
}
