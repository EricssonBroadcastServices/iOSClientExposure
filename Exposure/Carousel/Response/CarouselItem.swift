//
//  CarouselItem.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-10-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

struct CarouselItem: Decodable {
  let id: String
  let sortOrder: Int
  let items: AssetList
  let titles: [[String: String]]
}
