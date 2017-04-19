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
    
    public let sessionToken: SessionToken?
    public let crmToken: String?
    public let accountId: String?
    public let expiration: Date?
    public let accountStatus: String?
}

extension Credentials: ExposureConvertible {
    public init?(json: JSON) {
        let actualJson = SwiftyJSON.JSON(json)
        
        sessionToken = SessionToken(value: actualJson[JSONKeys.sessionToken.rawValue].string)
        
        crmToken = actualJson[JSONKeys.crmToken.rawValue].string
        accountId = actualJson[JSONKeys.accountId.rawValue].string
        
        if let jExpiration = actualJson[JSONKeys.expiration.rawValue].string {
            expiration = Date
                .utcFormatter()
                .date(from: jExpiration)
        }
        else {
            expiration = nil
        }
        
        accountStatus = actualJson[JSONKeys.accountStatus.rawValue].string
    }
    
    public func toJson() -> JSON {
        var json: [String: Any] = [:]
        if let sessionToken = sessionToken { json[JSONKeys.sessionToken.rawValue] = sessionToken.value }
        if let crmToken = sessionToken { json[JSONKeys.crmToken.rawValue] = crmToken }
        if let accountId = sessionToken { json[JSONKeys.accountId.rawValue] = accountId }
        if let expiration = sessionToken { json[JSONKeys.expiration.rawValue] = expiration }
        if let accountStatus = sessionToken { json[JSONKeys.accountStatus.rawValue] = accountStatus }
        return json
    }
}
