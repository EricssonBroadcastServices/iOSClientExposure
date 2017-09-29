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
    public var userDataIncluded: Bool {
        return userDataFilter.sessionToken != nil
    }
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
