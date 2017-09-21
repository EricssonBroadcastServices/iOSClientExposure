//
//  SessionResponse.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-04.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Returned when validating a `SessionToken`
public struct SessionResponse: Decodable {

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

