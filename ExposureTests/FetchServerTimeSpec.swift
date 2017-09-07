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

enum MapErrorTestError: Error {
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
                        .response{ (exposureResponse: ExposureResponse<ServerTime>) in
                            serverTime = exposureResponse.value
                            error = exposureResponse.error
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
            
            context("MapError") { // MockingJay does not work well with `validate()`
                let exposureErrorJson:[String: Any] = [
                    "httpCode": 404,
                    "message":"FAKE_EXPOSURE_ERROR"
                ]
                self.stub(uri(fetch.endpointUrl), json(exposureErrorJson, status: 404))
                
                var result: ServerTime? = nil
                var mappedError: ExposureError? = nil
                fetch
                    .request()
                    .validate()
                    .mapError{ (error, data) in
                        return ExposureError.generalError(error: MapErrorTestError.expectedMappedError)
                    }
                    .response{ (exposureResponse: ExposureResponse<ServerTime>) in
                        result = exposureResponse.value
                        mappedError = exposureResponse.error
                        
                }
                
                it("should mapError") {
                    expect(result).toEventually(beNil())
                    expect(mappedError).toEventually(matchError(ExposureError.generalError(error: MapErrorTestError.expectedMappedError)))
                }
            }
            
            context("Validating contentType") {
                beforeEach {
                    self.stub(uri(fetch.endpointUrl), json(expectedJson))
                    
                    fetch
                        .request()
                        .validate(contentType: ["application/json"])
                        .response{ (exposureResponse: ExposureResponse<ServerTime>) in
                            serverTime = exposureResponse.value
                            error = exposureResponse.error
                    }
                }
                
                it("should have valid contentType") {
                    expect(serverTime).toEventuallyNot(beNil())
                    expect(error).toEventually(beNil())
                }
            }
        }
    }
}
