//
//  AnonymousSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import iOSClientExposure

class AnonymousSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        var env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        
        env.version = "v2"
        
        let anonymous = Authenticate(environment: env)
            .anonymous()
        
        describe("Anonymous") {
            it("should have no headers") {
                expect(anonymous.headers).to(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/auth/anonymous"
                expect(anonymous.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
        }
    }
}
