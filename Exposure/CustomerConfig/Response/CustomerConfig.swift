//
//  CustomerConfig.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-10-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct CustomerConfig: Codable {
  let customer: String
  let businessUnit: String
  let fileNames: [String]

  public struct File: Decodable {
    let data: [String: AnyJSONType]
  }
}
