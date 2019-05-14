//
//  PlaybackEntitlementV2.swift
//  Exposure-iOS
//
//  Created by Udaya Sri Senarathne on 2019-04-08.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation

public struct PlayBackEntitlementV2: Decodable {
    
    public let requestId: String?
    
    public let bookmarks: BooksMarks?
    
    public let contractRestrictions: ContractRestrictions?
    
    public let entitlementType: String?
    
    public let formats: [Formats]?
    
    public let playSessionId: String
    
    public let playToken: String
    
    public let playTokenExpiration: Int
    
    public let productId: String
    
    public let publicationId: String?
    
    public let streamInfo: StreamInfo
}


extension PlayBackEntitlementV2 {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        requestId = try container.decodeIfPresent(String.self, forKey: .requestId)
        bookmarks = try container.decodeIfPresent(BooksMarks.self, forKey: .bookmarks)
        contractRestrictions = try container.decodeIfPresent(ContractRestrictions.self, forKey: .contractRestrictions)
        entitlementType = try container.decodeIfPresent(String.self, forKey: .entitlementType)
        formats = try container.decodeIfPresent([Formats].self, forKey: .formats)?.filter({ $0.format == "HLS"})
        playSessionId = try container.decode(String.self, forKey: .playSessionId)
        playToken = try container.decode(String.self, forKey: .playToken)
        playTokenExpiration = try container.decode(Int.self, forKey: .playTokenExpiration)
        productId = try container.decode(String.self, forKey: .productId)
        publicationId = try container.decodeIfPresent(String.self, forKey: .publicationId)
        streamInfo = try container.decode(StreamInfo.self, forKey: .streamInfo)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case requestId
        case bookmarks
        case contractRestrictions
        case entitlementType
        case formats
        case playSessionId
        case playToken
        case playTokenExpiration
        case productId
        case publicationId
        case streamInfo
    }
}


