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
    public let data: [String: AnyJSONType]
  }
}
