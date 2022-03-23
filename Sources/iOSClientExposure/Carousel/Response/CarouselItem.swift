//
//  CarouselItem.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-10-03.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/**
 * CarouselItem
 *
 * Stores the localized title of the carousel and it's assets
 */
public struct CarouselItem: Decodable {

    /// ID of the carousel
    public let carouselId: String?

    /// ??
    public let sortOrder: Int?

    /// List of assets
    public let items: AssetList?

    /// Localized titles for carousel
    public let titles: [LocalizedData]?
}
