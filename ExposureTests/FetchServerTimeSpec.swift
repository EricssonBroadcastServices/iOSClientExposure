//
//  FetchServerTimeSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-24.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble
import Mockingjay

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
        
        describe("Request") {
            let expectedJson:[String: Any] = [
                "epochMillis": 1000,
                "iso8601":"ISOTIME"
            ]
            
            var serverTime: ServerTime?
            var error: ExposureError?
            
            beforeEach {
                serverTime = nil
                error = nil
            }
            
            context("Success") {
                
                beforeEach {
                    self.stub(uri(fetch.endpointUrl), json(expectedJson))
                    
                    fetch
                        .request()
                        .response{
                            serverTime = $0.value
                            error = $0.error
                    }
                }
                
                it("should receive correct response") {
                    expect(serverTime).toEventuallyNot(beNil())
                    expect(error).toEventually(beNil())
                    
                    expect(serverTime!.iso8601).toEventuallyNot(beNil())
                    expect(serverTime!.epochMillis).toEventuallyNot(beNil())
                    
                    expect(serverTime!.iso8601).toEventually(equal("ISOTIME"))
                    expect(serverTime!.epochMillis).toEventually(equal(1000))
                }
            }
        }
    }
}
