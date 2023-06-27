//
//  Authenticate.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Authenticate through *Exposure*
public struct Authenticate {
    /// Environment to use
    public let environment: Environment
    
    public init(environment: Environment) {
        self.environment = environment
    }
}

extension Authenticate {
    /// Authentication with `username` and `password`.
    ///
    /// - parameter username: username to authenticate with
    /// - parameter password: password associated with `username`
    /// - parameter twoFactor: twoFactor auth code if requested
    /// - parameter rememberMe: `true` extends period of session validity, `false` uses normal validation period.
    /// - returns: `Login` struct used to process the request.
    public func login(username: String, password: String, twoFactor: String? = nil, rememberMe: Bool = false) -> Login {
        return Login(username: username, password: password, twoFactor: twoFactor, rememberMe: rememberMe, environment: environment)
    }
    
    
    public func loginWithFirebase(firebaseToken: String, providerId: String, username: String?, language: String?, email: String?, displayName: String? ) -> FirebaseLogin {
        return FirebaseLogin(environment: environment, username: username, language: language, email: email, displayName: displayName, accessToken: firebaseToken, providerId: providerId)
    }
    
    /// Anonymous authentication.
    /// 
    /// - returns: `Anonymous` struct used to process the request.
    public func anonymous() -> Anonymous {
        return Anonymous(environment: environment)
    }
    
    /// Log out and invalidate `sessionToken`.
    ///
    /// - parameter sessionToken: the session to invalidate
    /// - returns: `Logout` struct used to process the request.
    public func logout(sessionToken: SessionToken) -> Logout {
        return Logout(sessionToken: sessionToken,
                      environment: environment)
    }
    
    public func validate(sessionToken: SessionToken) -> ValidateSessionToken {
        return ValidateSessionToken(sessionToken: sessionToken,
                                    environment: environment)
    }
}
