//
//  CheckEntitle.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2021-11-04.
//  Copyright © 2021 emp. All rights reserved.
//

import Foundation

public struct CheckEntitleResponse: Decodable {
    
    public let accountId: String?
    
    public let requestId: String?

    public let productId: String?
    
    public let publicationId: String?
    
    public let streamInfo: StreamInfo?
    
    public let status: String?
    
}

extension CheckEntitleResponse {
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
