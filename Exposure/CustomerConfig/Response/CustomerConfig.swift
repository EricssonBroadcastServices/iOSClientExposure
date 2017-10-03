//
//  CustomerConfig.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-10-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct CustomerConfig: Codable {
  public let customer: String
  public let businessUnit: String
  public let fileNames: [String]
  
  public struct File: Decodable {
    public let customer: String
    public let businessUnit: String
    public let fileName: String
    public let config: [String: AnyJSONType]
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      customer = try container.decode(String.self, forKey: .customer)
      businessUnit = try container.decode(String.self, forKey: .businessUnit)
      fileName = try container.decode(String.self, forKey: .fileName)
      config = try container.decode([String: AnyJSONType].self, forKey: .config)
    }

    internal enum CodingKeys: String, CodingKey {
      case customer
      case businessUnit
      case fileName
      case config
    }
  }
}

