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
import SwiftyJSON

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
        let rememberMe = false
        
        describe("Login Basics") {
            let login = Login(username: username, password: password, rememberMe: rememberMe, environment: env)
            
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
    }
}
