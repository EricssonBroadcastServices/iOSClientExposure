//
//  AnonymousSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble
import Mockingjay

@testable import Exposure

class AnonymousSpec: QuickSpec {
    var endpointStub: Stub?
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        
        let anonymous = Anonymous(environment: env)
        
        let expectedSessionToken = "sessionToken"
        let expectedCrmToken = "crmToken"
        let expectedAccountId = "accountId"
        let expectedExpirationDate = Date()
        let expectedAccountStatus = "accountStatus"
        let expectedCredentials = Credentials(sessionToken: SessionToken(value: expectedSessionToken),
                                              crmToken: expectedCrmToken,
                                              accountId: expectedAccountId,
                                              expiration: expectedExpirationDate,
                                              accountStatus: expectedAccountStatus)
        let expectedJson = expectedCredentials.toJson()
        
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
            var date: Date?
            
            beforeEach {
                request = nil
                response = nil
                data = nil
                credentials = nil
                token = nil
                date = nil
            }
            /*
            context("Success") {
                beforeEach {
                    print(expectedJson)
                    
                    self.stub(uri(anonymous.endpointUrl), json(expectedJson))
                    
                    anonymous
                        .request(.post)
                        .response{ (exposureResponse: ExposureResponse<Credentials>) in
                            request = exposureResponse.request
                            response = exposureResponse.response
                            data = exposureResponse.data
                            credentials = exposureResponse.value
                            token = credentials?.sessionToken
                            date = credentials?.expiration
                    }
                }
                
                it("should eventually return a response") {
                    
                    expect(request).toEventuallyNot(beNil())
                    expect(response).toEventuallyNot(beNil())
                    expect(data).toEventuallyNot(beNil())
                    expect(credentials).toEventuallyNot(beNil())
                    expect(token).toEventuallyNot(beNil())
                    expect(date).toEventuallyNot(beNil())
                    
                    expect(credentials!.accountId).toEventually(equal(expectedAccountId))
                    expect(credentials!.accountStatus).toEventually(equal(expectedAccountStatus))
                    expect(credentials!.crmToken).toEventually(equal(expectedCrmToken))
                    
                    expect(Date.utcFormatter().string(from: date!)).toEventually(equal(Date.utcFormatter().string(from: expectedExpirationDate)))
                    
                    expect(token!.value).toEventually(equal(expectedSessionToken))
                }
            }*/
            /*
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
            }*/
        }
    }
}
