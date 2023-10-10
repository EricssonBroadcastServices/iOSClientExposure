//
//  PlaybackEntitlementV2.swift
//  Exposure-iOS
//
//  Created by Udaya Sri Senarathne on 2019-04-08.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation

public struct PlayBackEntitlementV2: Codable {
    
    public let assetId: String?
    
    public let accountId: String?
    
    public let audioOnly:Bool?
    
    public let requestId: String?
    
    public let bookmarks: BooksMarks?

    public let contractRestrictions: ContractRestrictions?
    
    public let entitlementType: String?
    
    public let formats: [Formats]?
    
    public let playSessionId: String
    
    public let playToken: String?
    
    public let playTokenExpiration: Int
    
    public let productId: String
    
    public let publicationId: String?
    
    public var publicationEnd: String?
    
    public let streamInfo: StreamInfo?
    
    public let ads: Ads?
    
    public let sprites:[Sprites]?
    
    public let analytics: AnalyticsFromEntitlement?
    
    public let cdn: CDNInfoFromEntitlement?
    
    public let durationInMs: Double?
    
    public let epg: EPG?
}


extension PlayBackEntitlementV2 {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        assetId = try container.decodeIfPresent(String.self, forKey: .assetId)
        
        accountId = try container.decodeIfPresent(String.self, forKey: .accountId)
        
        audioOnly =  try container.decodeIfPresent(Bool.self, forKey: .audioOnly)
        
        requestId = try container.decodeIfPresent(String.self, forKey: .requestId)
        bookmarks = try container.decodeIfPresent(BooksMarks.self, forKey: .bookmarks)
        contractRestrictions = try container.decodeIfPresent(ContractRestrictions.self, forKey: .contractRestrictions)
        entitlementType = try container.decodeIfPresent(String.self, forKey: .entitlementType)
        formats = try container.decodeIfPresent([Formats].self, forKey: .formats)?.filter({ $0.format == "HLS" || $0.format == "MP3" })
        playSessionId = try container.decode(String.self, forKey: .playSessionId)
        playToken = try container.decodeIfPresent(String.self, forKey: .playToken)
        playTokenExpiration = try container.decode(Int.self, forKey: .playTokenExpiration)
        productId = try container.decode(String.self, forKey: .productId)
        publicationId = try container.decodeIfPresent(String.self, forKey: .publicationId)
        publicationEnd = try container.decodeIfPresent(String.self, forKey: .publicationEnd)
        streamInfo = try container.decodeIfPresent(StreamInfo.self, forKey: .streamInfo)
        ads = try container.decodeIfPresent(Ads.self, forKey: .ads)
        sprites = try container.decodeIfPresent([Sprites].self, forKey: .sprites)
        analytics = try container.decodeIfPresent(AnalyticsFromEntitlement.self, forKey: .analytics)
        cdn = try container.decodeIfPresent(CDNInfoFromEntitlement.self, forKey: .cdn)
        durationInMs = try container.decodeIfPresent(Double.self, forKey: .durationInMs)
        epg = try container.decodeIfPresent(EPG.self, forKey: .epg)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case assetId
        case accountId
        case requestId
        case bookmarks
        case audioOnly
        case contractRestrictions
        case entitlementType
        case formats
        case playSessionId
        case playToken
        case playTokenExpiration
        case productId
        case publicationId
        case publicationEnd
        case streamInfo
        case ads
        case sprites
        case analytics
        case cdn
        case durationInMs
        case epg

    }
}

extension PlayBackEntitlementV2 {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(assetId, forKey: .assetId)
        try container.encode(accountId, forKey: .accountId)
        try container.encode(audioOnly, forKey: .audioOnly)
        
        try container.encode(requestId, forKey: .requestId)
        try container.encode(bookmarks, forKey: .bookmarks)
        try container.encode(contractRestrictions, forKey: .contractRestrictions)
        try container.encode(entitlementType, forKey: .entitlementType)
        try container.encode(formats, forKey: .formats)
        try container.encode(playSessionId, forKey: .playSessionId)
        try container.encode(playToken, forKey: .playToken)
        try container.encode(playTokenExpiration, forKey: .playTokenExpiration)
        try container.encodeIfPresent(productId, forKey: .productId)
        try container.encodeIfPresent(publicationId, forKey: .publicationId)
        try container.encodeIfPresent(publicationEnd, forKey: .publicationEnd)
        try container.encodeIfPresent(streamInfo, forKey: .streamInfo)
        try container.encodeIfPresent(ads, forKey: .ads)
        try container.encodeIfPresent(sprites, forKey: .sprites)
        try container.encodeIfPresent(analytics, forKey: .analytics)
        try container.encodeIfPresent(cdn, forKey: .cdn)
        try container.encodeIfPresent(durationInMs, forKey: .durationInMs)
        try container.encodeIfPresent(epg, forKey: .epg)
    }
}


