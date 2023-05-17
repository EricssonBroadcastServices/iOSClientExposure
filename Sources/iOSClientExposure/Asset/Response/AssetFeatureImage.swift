//
//  AssetFeatureImage.swift
//  Pods
//
//  Created by Alessandro dos Santos Pinto on 2023-05-02.
//

import Foundation

public struct AssetFeatureImage: Codable {
    
    public let url: String?
    public let selectors: [String]?
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(selectors, forKey: .selectors)
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        url = try container.decodeIfPresent(String.self, forKey: .url)
        selectors = try container.decodeIfPresent([String].self, forKey: .selectors)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case url
        case selectors
    }
}
