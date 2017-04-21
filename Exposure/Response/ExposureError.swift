//
//  ExposureError.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-27.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public enum ExposureError: Error {
    case generalError(error: Error)
    case serialization(reason: SerializationFailureReason)
    case exposureResponse(reason: ExposureResponseMessage)
    case none
    
    public enum SerializationFailureReason {
        case jsonSerialization(error: Error)
        case objectSerialization(reason: String, json: Any)
    }
    
    
    //case authorization(reason: AuthorizationFailureReason)
    //case generalFailure(reason: GeneralFailureReason)
    
    
    /*
     public enum AuthorizationFailureReason {
     case invalidSessionToken // If the session token is invalid
     case forbidden //  If the business unit is not configured to support anonymous sessions.
     
     case deviceLimitExceeded // If the account has exceeded the number of allowed devices.
     case sessionLimitExceeded // If the account has exceeded the number of allowed sessions.
     case unknownDeviceId // If the device body is not included and the device id is not found.
     case thirdPartyError // If third party login generate error message, for detail error code see field extendedMessage.
     case incorrectCredentials // If the underlying CRM does not deem the credentials valid.
     }
     
     
     public enum GeneralFailureReason {
     case unknownBusinessUnit // If the business unit cannot be found.
     
     case invalidJSON // If JSON received is not valid JSON.
     case jsonDoesNotFollowContract // If the JSON does not follow the contract. I.E. unknown ENUM sent, strings in place of integers, missing values etc.
     
     }*/
}
