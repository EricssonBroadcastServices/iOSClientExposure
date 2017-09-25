//
//  Credentials.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// `Credentials` response returned on a successful login attempt.
public struct Credentials: Decodable {
    /// Keys used to specify `json` body for the request.
    fileprivate enum CodingKeys: String, CodingKey {
        case sessionToken, crmToken, accountId, accountStatus
        case expiration = "expirationDateTime"
    }
    
    /// The session token to use for subsequent requests.
    public let sessionToken: SessionToken
    
    ///  The token of the underlying CRM to use if talking directly to the CRM.
    public let crmToken: String?
    
    /// The id of the account in the CRM.
    public let accountId: String?
    
    /// The time when the session expires
    public let expiration: Date?
    
    /// The status of the account
    public let accountStatus: String?
    
    public init(sessionToken: SessionToken, crmToken: String?, accountId: String?, expiration: Date?, accountStatus: String?) {
        self.sessionToken = sessionToken
        self.crmToken = crmToken
        self.accountId = accountId
        self.expiration = expiration
        self.accountStatus = accountStatus
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sessionToken = SessionToken(value: try container.decode(String.self, forKey: .sessionToken))
        crmToken = try container.decodeIfPresent(String.self, forKey: .crmToken)
        accountId = try container.decodeIfPresent(String.self, forKey: .accountId)
        accountStatus = try container.decodeIfPresent(String.self, forKey: .accountStatus)
        expiration = try container.decodeIfPresent(Date.self, forKey: .expiration)
    }
}
