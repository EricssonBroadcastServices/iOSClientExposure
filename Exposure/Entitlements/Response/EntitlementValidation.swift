//
//  EntitlementValidation.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct EntitlementValidation: ExposureConvertible {
    public typealias Status = PlaybackEntitlement.Status
    
    ///  The status of the entitlement
    public let status: Status?
    
    // The status of the payment
    public let paymentDone: Bool?
    
    public init?(json: Any){
        let actualJSON = SwiftyJSON.JSON(json)
        
        status = Status(string: actualJSON[JSONKeys.status.rawValue].string)
        paymentDone = actualJSON[JSONKeys.paymentDone.rawValue].bool
        
        if status == nil && paymentDone == nil { return nil }
    }
    
    internal enum JSONKeys: String {
        case status = "status"
        case paymentDone = "paymentDone"
    }
}
