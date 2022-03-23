//
//  CarouselList.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-10-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/**
 * CarouselList
 *
 * Stores an array of `CarouselItems`
 */
public struct CarouselList: Decodable {

    /// CarouselItems returned by api
    public let items: [CarouselItem]?

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        items = try? container.decode([CarouselItem].self)
    }
}

