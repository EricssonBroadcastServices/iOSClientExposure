//
//  AnonymousSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class AnonymousSpec: QuickSpec {
    override func spec() {
        describe("Anonymous") {
            let base = "http://base.url.com"
            let customer = "TestCustomer"
            let businessUnit = "TestBusinessUnit"
            let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
            
            let anonymous = Anonymous(environment: env)
            
            it("should have no headers") {
                expect(anonymous.headers).to(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/auth/anonymous"
                expect(anonymous.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let json = anonymous.deviceInfo.toJSON()
                expect(anonymous.parameters.count).to(equal(json.count))
            }
        }
    }
}
