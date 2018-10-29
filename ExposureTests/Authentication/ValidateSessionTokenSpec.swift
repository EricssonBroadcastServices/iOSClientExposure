//
//  ValidateSessionTokenSpec.swift
//  ExposureTests
//
//  Created by Fredrik Sjöberg on 2017-09-04.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class ValidateSessionTokenSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let sessionToken = SessionToken(value: "TOKEN")
        
        let request = ValidateSessionToken(sessionToken: sessionToken, environment: env)
        
        describe("Validation Basics") {
            it("should have headers") {
                expect(request.headers).toNot(beNil())
                expect(request.headers!).to(equal(sessionToken.authorizationHeader))
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/auth/session"
                expect(request.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate no paramters") {
                let params = request.parameters
                
                expect(params).to(beNil())
            }
        }
    }
}
