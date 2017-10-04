//
//  CarouselItem.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-10-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct CarouselItem: Decodable {
  let carouselId: String?
  let sortOrder: Int?
  let items: AssetList?
  let titles: [LocalizedData]?
}
