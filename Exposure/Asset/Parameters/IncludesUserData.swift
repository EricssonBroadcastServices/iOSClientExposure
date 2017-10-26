//
//  IncludesUserData.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public protocol IncludesUserData {
    var userDataFilter: UserDataFilter { get set }
}

extension IncludesUserData {
    /// Should user specific data be included in the result
    public var userDataIncluded: Bool {
        return userDataFilter.sessionToken != nil
    }
    
    /// If user specific data should be included in the result. If set to true the request response time will increase. Authorization header is needed for getting user data.
    public func includeUserData(for sessionToken: SessionToken) -> Self {
        var old = self
        old.userDataFilter = UserDataFilter(sessionToken: sessionToken)
        return old
    }
}

public struct UserDataFilter {
    internal let sessionToken: SessionToken?
    
    internal init(sessionToken: SessionToken? = nil) {
        self.sessionToken = sessionToken
    }
}
