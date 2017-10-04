//
//  CarouselItem.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-10-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct CarouselItem: Decodable {
  public let carouselId: String?
  public let sortOrder: Int?
  public let items: AssetList?
  public let titles: [LocalizedData]?
}
