//
//  Error+Extensions.swift
//  Exposure-iOS
//
//  Created by Fredrik Sjöberg on 2018-09-18.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

extension Error {
    internal var debugInfoString: String {
        if let nsError = self as? NSError {
            var message = "[\(nsError.code):\(nsError.domain)] \n "
            message += "[\(nsError.debugDescription)] \n "
            
            if let uError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError {
                message += uError.debugInfoString
            }
            return message
        }
        return "[\(self.localizedDescription)] \n"
    }
}
