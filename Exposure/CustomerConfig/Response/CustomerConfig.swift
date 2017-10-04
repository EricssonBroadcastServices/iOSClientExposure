//
//  CustomerConfig.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-10-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct CustomerConfig: Codable {

    /// The CustomerUnit which made the call
    public let customer: String

    /// The BusinessUnit which made the call
    public let businessUnit: String

    /// Files stored in the databse
    public let fileNames: [String]

    public struct File: Decodable {

        /// The CustomerUnit which made the call
        public let customer: String

        /// The BusinessUnit which made the call
        public let businessUnit: String

        /// Filename of current requested file
        public let fileName: String

        /// The config stored in the file.
        /// Could be an array or Dictionary
        public let config: AnyJSONType

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            customer = try container.decode(String.self, forKey: .customer)
            businessUnit = try container.decode(String.self, forKey: .businessUnit)
            fileName = try container.decode(String.self, forKey: .fileName)
            config = try container.decode(AnyJSONType.self, forKey: .config)
        }

        internal enum CodingKeys: String, CodingKey {
            case customer
            case businessUnit
            case fileName
            case config
        }
    }
}

