//
//  SessionToken.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-03-22.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import SwiftyJSON

/// `SessionToken` represents an authenticated *session* as recognized by *Exposure*
///
/// The token itself is by no means guaranteed to be valid, it merely represents the expected form.
///
/// For more information regarding `SessionToken`s, authentication requests and managing user sessions, please see [User Authentication]() in the documentation.
public struct SessionToken {
    /// Keys used to specify `json` body for the request.
    fileprivate enum JSONKeys: String {
        case sessionToken = "sessionToken"
    }
    
    public let value: String
    
    /// Most *Exposure* endpoints require an *authenticated* session for access. `authorizationHeader` provides this in an expected format.
    public var authorizationHeader: [String: String] {
        return ["Authorization": "Bearer " + value]
    }
    
    public init(value: String) {
        self.value = value
    }
    
    /// There is no point in initializing a `SessionToken` without a value. Doing so will return `nil`
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
    public var crmToken: String? {
        return components.first
    }
    
    /// The id of the account in the CRM.
    public var accountId: String? {
        let comp = components
        guard comp.count >= 1 else { return nil }
        return comp[1]
    }
    
    /// The user id
    public var userId: String? {
        let comp = components
        guard comp.count >= 2 else { return nil }
        return comp[2]
    }
    
    /// Returns true if this session token is anonymous
    public var isAnonymous: Bool? {
        let comp = components
        guard comp.count >= 6 else { return nil }
        switch comp[6] {
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
