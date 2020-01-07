//
//  File.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-01-07.
//  Copyright © 2020 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class UpdateUserDetailsSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        var env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let sessionToken = SessionToken(value: "token")
        
        env.version = "v2"
        
        let userDetails = UpdateUserDetails(environment: env, sessionToken: sessionToken, language: "en")
        
        describe("Update UserDetails") {
            it("should have headers") {
                expect(userDetails.headers).toNot(beNil())
                expect(userDetails.headers!).to(equal(sessionToken.authorizationHeader))
            }
            
            it("Should fail with invalid endpoint url") {
                let endpoint = "/user/details/"
                expect(userDetails.endpointUrl).toNot(equal(env.apiUrl+endpoint))
            }
            
            it("should generate a correct endpoint url") {
                env.version = "v2"
                let endpoint = "/user/details/"
                expect(userDetails.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
        }
        
    }
}
