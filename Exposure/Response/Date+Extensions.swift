//
//  ExposureError.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Date {
    public static func utcFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }
    
    public var millisecondsSince1970: UInt64 {
        return UInt64((timeIntervalSince1970 * 1000.0).rounded())
    }
    
    public init(milliseconds: UInt64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
