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

extension SessionToken: Equatable {
    public static func == (lhs: SessionToken, rhs: SessionToken) -> Bool {
        return lhs.value == rhs.value
    }
}

extension SessionToken {
    /// Parses the session token into its constituents
    fileprivate var components: [String] {
        return value.components(separatedBy: "|")
    }
}

extension SessionToken {
    ///  The token of the underlying CRM to use if talking directly to the CRM.
    public var crmToken: String {
        return components[0]
    }
    
    /// The id of the account in the CRM.
    public var accountId: String {
        return components[1]
    }
    
    /// The user id
    public var userId: String {
        return components[2]
    }
    
    /// Returns true if this session token is anonymous
    public var isAnonymous: Bool? {
        switch components[6] {
        case "true": return true
        case "false": return false
        default: return nil
        }
    }
    
    /// Returns true if the session token has the correct format
    public var hasValidFormat: Bool {
        return components.count == 9
    }
}

extension SessionToken: ExposureConvertible {
    public init?(json: Any) {
        let actualJson = SwiftyJSON.JSON(json)
        guard let jSessionToken = actualJson[JSONKeys.sessionToken.rawValue].string else { return nil }
        value = jSessionToken
    }
}
