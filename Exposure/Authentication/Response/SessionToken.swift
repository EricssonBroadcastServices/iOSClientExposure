//
//  SessionToken.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-22.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct SessionToken {
    fileprivate enum JSONKeys: String {
        case sessionToken = "sessionToken"
    }
    
    public let value: String
    
    
    public var authorizationHeader: [String: String] {
        return ["Authorization": "Bearer " + value]
    }
    
    public init(value: String) {
        self.value = value
    }
    
    public init?(value: String?) {
        guard let val = value else {
            return nil
        }
        self.value = val
    }
}

extension SessionToken: ExposureConvertible {
    public init?(json: Any) {
        let actualJson = SwiftyJSON.JSON(json)
        guard let jSessionToken = actualJson[JSONKeys.sessionToken.rawValue].string else { return nil }
        value = jSessionToken
    }
}
