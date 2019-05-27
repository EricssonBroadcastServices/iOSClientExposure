//
//  MediaFormat.swift
//  Exposure-iOS
//
//  Created by Udaya Sri Senarathne on 2019-04-08.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation

public struct Formats: Codable {
    
    //public let adMediaLocator: URL?
    public let format: String
    public let mediaLocator: URL
    public var fairplay = [FairplayConfiguration]()
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        format = try container.decode(String.self, forKey: .format)
        
        mediaLocator = try container.decode(URL.self, forKey: .mediaLocator)
        
        self.fairplay = [FairplayConfiguration]()
        
        if container.allKeys.contains(.drm) {
            
            let subContainer = try container.nestedContainer(keyedBy: GenericCodingKeys.self, forKey: .drm)
            
            for key in subContainer.allKeys {
                let fairplay = try subContainer.decode(FairplayConfiguration.self, forKey: key)
                self.fairplay.append(fairplay)
            }
        }
    }
    
    internal enum CodingKeys: String, CodingKey {
        // case adMediaLocator
        case drm
        case format
        case mediaLocator
    }
    
    internal enum Content: CodingKey {
        case certificateUrl
        case licenseAcquisitionUrl
    }
}

extension Formats {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(format, forKey: .format)
        try container.encode(mediaLocator, forKey: .mediaLocator)
    }
}

struct GenericCodingKeys: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int? { return nil }
    
    init?(intValue: Int) { return nil }
}

