//
//  EnvironmentSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class EnvironmentSpec: QuickSpec {
    override func spec() {
        describe("Environment") {
            let base = "http://base.url.com"
            let customer = "TestCustomer"
            let businessUnit = "TestBusinessUnit"
            let basePath = "/v1/customer/" + customer + "/businessunit/" + businessUnit
            let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
            
            it("should build a correct base path") {
                expect(env.basePath).to(equal(basePath))
            }
            
            it("should build a correct apiURL") {
                expect(env.apiUrl).to(equal(base+basePath+"NOT CORRECT"))
            }
        }
    }
}
