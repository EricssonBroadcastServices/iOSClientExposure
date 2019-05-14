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
            let version = "v1"
            let basePath = "/" + version + "/customer/" + customer + "/businessunit/" + businessUnit
            
            let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit, version: version)
           
           it ("should build a correct base path") {
                expect(env.basePath).to(equal(basePath))
            }
            
            it("should build a correct apiURL") {
                expect(env.apiUrl).to(equal(base+basePath))
            }
            
            it ("should equal the versions") {
                expect(env.version).to(equal(version))
            }
            
            /* it ("Should not equal the versions") {
                let versionTwo = "v2"
                expect(env.version).notTo(equal(versionTwo))
            } */ 
        }
    }
    
    
}
