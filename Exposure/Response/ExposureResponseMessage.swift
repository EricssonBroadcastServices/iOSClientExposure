//
//  ExposureResponseMessage.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ExposureResponseMessage: ExposureConvertible {
    public let httpCode: Int
    public let message: String
    
    public init?(json: Any) {
        let actualJSON = SwiftyJSON.JSON(json)
        guard let httpCode = actualJSON["httpCode"].int,
            let message = actualJSON["message"].string else { return nil }
        self.httpCode = httpCode
        self.message = message
    }
}

extension ExposureResponseMessage {
    public var localizedDescription: String {
        return "Exposure response returned httpCode: [\(httpCode)] with message: \(message)"
    }
}
