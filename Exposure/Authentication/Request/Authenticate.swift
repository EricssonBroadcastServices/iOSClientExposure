//
//  Authenticate.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct Authenticate {
    public let environment: Environment
    
    public init(environment: Environment) {
        self.environment = environment
    }
}

extension Authenticate {
    public func login(username: String, password: String, rememberMe: Bool = false) -> Login {
        return Login(username: username, password: password, rememberMe: rememberMe, environment: environment)
    }
    
    public func anonymous() -> Anonymous {
        return Anonymous(environment: environment)
    }
    
    public func twoFactor(username: String, password: String, twoFactor: String, rememberMe: Bool = false) -> TwoFactorLogin {
        return TwoFactorLogin(username: username, password: password, twoFactor: twoFactor, rememberMe: rememberMe, environment: environment)
    }
    
    public func logout(sessionToken: SessionToken) -> Logout {
        return Logout(sessionToken: sessionToken,
                      environment: environment)
    }
}
