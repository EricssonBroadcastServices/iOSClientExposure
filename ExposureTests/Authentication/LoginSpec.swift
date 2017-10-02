//
//  LoginSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-21.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble
import Mockingjay

@testable import Exposure

class LoginSpec: QuickSpec {
    var endpointStub: Stub?
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let username = "username"
        let password = "password"
        
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
            
            it("should generate paramters") {
                let params = login.parameters
                expect(params.count).to(equal(login.deviceInfo.toJSON().count+3))
                
                expect(params["username"]).toNot(beNil())
                expect(params["password"]).toNot(beNil())
                expect(params["rememberMe"]).toNot(beNil())
            }
        }
        
        describe("Two Factor") {
            it("should have no headers") {
                let twoFactor = Authenticate(environment: env)
                    .twoFactor(username: username, password: password, twoFactor: "token", rememberMe: true)
                expect(twoFactor.headers).to(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let twoFactor = Authenticate(environment: env)
                    .twoFactor(username: username, password: password, twoFactor: "token")
                let endpoint = "/auth/twofactorlogin"
                expect(twoFactor.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should convert to Two Factor auth") {
                let params = login.twoFactor(token: "token").parameters
                
                expect(params.count).to(equal(login.deviceInfo.toJSON().count+4))
                
                expect(params["username"]).toNot(beNil())
                expect(params["password"]).toNot(beNil())
                expect(params["rememberMe"]).toNot(beNil())
                expect(params["totp"]).toNot(beNil())
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
