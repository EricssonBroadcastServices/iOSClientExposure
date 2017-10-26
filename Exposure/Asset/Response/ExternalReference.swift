//
//  ExternalReference.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct ExternalReference: Codable {
    public let locator: String?
    public let type: String?
    public let value: String?
}
