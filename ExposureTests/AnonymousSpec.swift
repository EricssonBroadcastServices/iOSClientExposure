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
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        
        let anonymous = Anonymous(environment: env)
        
        describe("Anonymous") {
            
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
        
        describe("Anonymous Login Response") {
            // http://httpbin.org/
            
            var request: URLRequest?
            var response: URLResponse?
            var data: Data?
            var credentials: Credentials?
            var token: SessionToken?
            
            it("should eventually return a response") {
                anonymous
                    .request(.post)
                    .response{ (exposureResponse: ExposureResponse<Credentials>) in
                        request = exposureResponse.request
                        response = exposureResponse.response
                        data = exposureResponse.data
                        credentials = exposureResponse.value
                        token = credentials?.sessionToken
                }
                
                expect(request).toEventuallyNot(beNil())
                expect(response).toEventuallyNot(beNil())
                expect(data).toEventuallyNot(beNil())
                expect(credentials).toEventuallyNot(beNil())
                expect(token).toEventuallyNot(beNil())
            }
            
            it("should eventually return an error on invalid endpoint") {
                let invalidEnv = Environment(baseUrl: base, customer: "", businessUnit: "")
                let invalidAnonymous = Anonymous(environment: invalidEnv)
                
                var error: Error?
                invalidAnonymous
                    .request(.post)
                    .response{ (exposureResponse: ExposureResponse<Credentials>) in
                        error = exposureResponse.error
                }
                
                expect(error).toEventuallyNot(beNil())
            }
        }
    }
}
