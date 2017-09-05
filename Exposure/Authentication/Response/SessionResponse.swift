//
//  SessionResponse.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-04.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Returned when validating a `SessionToken`
public struct SessionResponse {
    /// Keys used to specify `json` body for the request.
    fileprivate enum JSONKeys: String {
        case crmToken = "crmToken"
        case accountId = "accountId"
        case userId = "userId"
    }
    
    /// The token within the crm.
    public let crmToken: String?
    
    /// The id of the account in the CRM.
    public let accountId: String?
    
    /// The user / profile id
    public let userId: String?
    
    public init(crmToken: String?, accountId: String?, expiration: Date?, userId: String?) {
        self.crmToken = crmToken
        self.accountId = accountId
        self.userId = userId
    }
}

extension SessionResponse: ExposureConvertible {
    public init?(json: Any) {
        let actualJson = SwiftyJSON.JSON(json)
        
        crmToken = actualJson[JSONKeys.crmToken.rawValue].string
        accountId = actualJson[JSONKeys.accountId.rawValue].string
        userId = actualJson[JSONKeys.userId.rawValue].string
        
        if crmToken == nil && accountId == nil && userId == nil { return nil }
    }
}
