//
//  LoginSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-21.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class LoginSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        var env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let username = "username"
        let password = "password"
        
        env.version = "v3"
        
        let login = Authenticate(environment: env)
            .login(username: username, password: password)
        
        describe("Login Basics") {
            
            it("should have no headers") {
                expect(login.headers).to(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/auth/login"
                expect(login.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
        }
        
        describe("Logout") {
            let logout = Authenticate(environment: env)
                .logout(sessionToken: SessionToken(value: "VALUE"))
            it("should have headers") {
                expect(logout.headers).toNot(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/auth/session"
                expect(logout.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should have no params") {
                let params = logout.parameters
                expect(params).to(beNil())
            }
        }
    }
}
