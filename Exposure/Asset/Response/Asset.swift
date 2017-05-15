//
//  Asset.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Asset: ExposureConvertible {
    
    public init?(json: Any) {
    }
    
    internal enum JSONKeys: String {
        case temp = "temp"
    }
}
