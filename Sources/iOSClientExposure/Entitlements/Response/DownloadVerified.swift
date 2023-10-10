//
//  DownloadVerified.swift
//  
//
//  Created by Udaya Sri Senarathne on 2023-10-03.
//

import Foundation


/// Download Verified reponse 
public struct DownloadVerified: Codable {
    public let assetId: String
    public let accountId: String
    public let productId: String
    public let publicationId: String
    public let publicationEnd: String

    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        assetId = try container.decode(String.self, forKey: .assetId)
        accountId = try container.decode(String.self, forKey: .accountId)
        productId = try container.decode(String.self, forKey: .productId)
        publicationId = try container.decode(String.self, forKey: .publicationId)
        publicationEnd = try container.decode(String.self, forKey: .publicationEnd)
        
    }
    
    internal enum CodingKeys: String, CodingKey {
        case assetId
        case accountId
        case productId
        case publicationId
        case publicationEnd
    }
}
