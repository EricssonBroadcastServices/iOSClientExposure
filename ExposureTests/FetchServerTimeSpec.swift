//
//  FetchServerTimeSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-24.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

enum MapErrorTestError: Swift.Error {
    case expectedMappedError
}

class FetchServerTimeSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        
        let fetch = FetchServerTime(environment: env)
        
        describe("FetchServerTime") {
            it("should have no headers") {
                expect(fetch.headers).to(beNil())
            }
            
            it("should have no parameters") {
                expect(fetch.parameters).to(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/time"
                expect(fetch.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
        }
    }
}
