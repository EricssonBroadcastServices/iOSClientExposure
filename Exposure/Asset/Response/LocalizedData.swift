//
//  LocalizedData.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct LocalizedData: Codable {
    public let locale: String?
    public let title: String?
    public let sortingTitle: String?
    public let description: String?
    public let tinyDescription: String?
    public let shortDescription: String?
    public let longDescription: String?
    public var images: [Image]?
}
