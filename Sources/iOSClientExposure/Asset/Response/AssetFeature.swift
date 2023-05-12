//
//  AssetFeature.swift
//  Pods
//
//  Created by Alessandro dos Santos Pinto on 2023-05-02.
//

import Foundation

public struct AssetFeature: Codable {
    public let id: String?
    public let images: [AssetFeatureImage]?
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(images, forKey: .images)
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        images = try container.decodeIfPresent([AssetFeatureImage].self, forKey: .images)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case id
        case images
    }
}
