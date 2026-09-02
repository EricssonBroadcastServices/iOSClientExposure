//
//  File.swift
//  iOSClientExposure
//
//  Created by Axel Nowaczyk on 13/04/2026.
//

import Foundation

public struct AdMarker: Codable {
	public let type: String?
	public let offset: Int?
	public let tagType: String?
	public let adTag: String?

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		type = try container.decodeIfPresent(String.self, forKey: .type)
		offset = try container.decodeIfPresent(Int.self, forKey: .offset)
		tagType = try container.decodeIfPresent(String.self, forKey: .tagType)
		adTag = try container.decodeIfPresent(String.self, forKey: .adTag)
	}

	internal enum CodingKeys: String, CodingKey {
		case type
		case offset
		case tagType
		case adTag
	}
}
