//
//  Credentials.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Credentials {
    fileprivate enum JSONKeys: String {
        case sessionToken = "sessionToken"
        case crmToken = "crmToken"
        case accountId = "accoundId"
        case expiration = "expirationDateTime"
        case accountStatus = "accountStatus"
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
}

extension Credentials: ExposureConvertible {
    public init?(json: Any) {
        let actualJson = SwiftyJSON.JSON(json)
        guard let jSessionToken = SessionToken(json: json) else { return nil }
        
        sessionToken = jSessionToken
        
        crmToken = actualJson[JSONKeys.crmToken.rawValue].string
        accountId = actualJson[JSONKeys.accountId.rawValue].string
        accountStatus = actualJson[JSONKeys.accountStatus.rawValue].string
        
        let jExpiration = actualJson[JSONKeys.expiration.rawValue].string
        if jExpiration != nil {
            expiration = Date
                .utcFormatter()
                .date(from: jExpiration!)
        }
        else {
            expiration = nil
        }
        
        
    }
    
    public func toJson() -> [String: Any] {
        var json: [String: Any] = [:]
        json[JSONKeys.sessionToken.rawValue] = sessionToken.value
        if let crmToken = crmToken { json[JSONKeys.crmToken.rawValue] = crmToken }
        if let accountId = accountId { json[JSONKeys.accountId.rawValue] = accountId }
        if let expiration = expiration {
            let expirationString = Date.utcFormatter().string(from: expiration)
            json[JSONKeys.expiration.rawValue] = expirationString
        }
        if let accountStatus = accountStatus { json[JSONKeys.accountStatus.rawValue] = accountStatus }
        return json
    }
}
