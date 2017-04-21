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
import SwiftyJSON

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
            var error: Error?
            
            beforeEach {
                request = nil
                response = nil
                data = nil
                credentials = nil
                token = nil
                date = nil
                error = nil
            }
            
            context("Success") {
                beforeEach {
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
                            error = exposureResponse.error
                    }
                }
                
                it("should eventually return a response") {
                    
                    expect(request).toEventuallyNot(beNil())
                    expect(response).toEventuallyNot(beNil())
                    expect(data).toEventuallyNot(beNil())
                    expect(credentials).toEventuallyNot(beNil())
                    expect(token).toEventuallyNot(beNil())
                    expect(date).toEventuallyNot(beNil())
                    expect(error).toEventually(beNil())
                    
                    expect(credentials!.accountId).toEventually(equal(expectedAccountId))
                    expect(credentials!.accountStatus).toEventually(equal(expectedAccountStatus))
                    expect(credentials!.crmToken).toEventually(equal(expectedCrmToken))
                    
                    expect(Date.utcFormatter().string(from: date!)).toEventually(equal(Date.utcFormatter().string(from: expectedExpirationDate)))
                    expect(token!.value).toEventually(equal(expectedSessionToken))
                }
            }
            
            let invalidEnv = Environment(baseUrl: base, customer: "WrongCustomer", businessUnit: "WrongBusinessUnit")
            let invalidAnonymous = Anonymous(environment: invalidEnv)
            
            let errorJson: [String: Any] = [
                "httpCode":404,
                "message":"UNKNOWN_BUSINESS_UNIT"
            ]
            context("Failure with invalid environment") {
                var httpCode: Int?
                var message: String?
                beforeEach {
                    self.stub(uri(invalidAnonymous.endpointUrl), json(errorJson, status: 404))
                    
                    invalidAnonymous
                        .request(.post)
                        .response{ (exposureResponse: ExposureResponse<Credentials>) in
                            request = exposureResponse.request
                            response = exposureResponse.response
                            data = exposureResponse.data
                            credentials = exposureResponse.value
                            token = credentials?.sessionToken
                            date = credentials?.expiration
                            error = exposureResponse.error
                            
                            if let data = data {
                                let json = JSON(data).dictionary
                                httpCode = json?["httpCode"]?.int
                                message = json?["message"]?.string
                            }
                    }
                }
                
                it("should throw an objectSerialization error without validate()") {
                    expect(data).toEventuallyNot(beNil())
                    expect(httpCode).toEventuallyNot(beNil())
                    expect(message).toEventuallyNot(beNil())
                    
                    expect(credentials).toEventually(beNil())
                    expect(error).toEventuallyNot(beNil())
                    expect(error).toEventually(matchError(ExposureError.serialization(reason: ExposureError.SerializationFailureReason.objectSerialization(reason: "Unable to serialize object", json: errorJson))))
                    
                    expect(httpCode).toEventually(equal(404))
                    expect(message).toEventually(equal("UNKNOWN_BUSINESS_UNIT"))
                }
            }
            
            context("Failure with invalid environment using validate()") {
                let exposureResponse = ExposureResponseMessage(json: errorJson)!
                beforeEach {
                    self.stub(uri(invalidAnonymous.endpointUrl), json(errorJson, status: 404))
                    
                    invalidAnonymous
                        .request(.post)
                        .validate()
                        .response{ (exposureResponse: ExposureResponse<Credentials>) in
                            request = exposureResponse.request
                            response = exposureResponse.response
                            data = exposureResponse.data
                            credentials = exposureResponse.value
                            token = credentials?.sessionToken
                            date = credentials?.expiration
                            error = exposureResponse.error
                    }
                }
                
                it("should throw an exposureResponse error when using validate()") {
                    expect(data).toEventuallyNot(beNil())
                    expect(credentials).toEventually(beNil())
                    expect(error).toEventuallyNot(beNil())
                    expect(error).toEventually(matchError(ExposureError.exposureResponse(reason: exposureResponse)))
                }
            }
            
            context("Failure with bad responseJson") {
                let invalidResponseJson = [["Invalid":"responseJson"]]
                beforeEach {
                    self.stub(uri(anonymous.endpointUrl), json(invalidResponseJson))
                    
                    anonymous
                        .request(.post)
                        .response{ (exposureResponse: ExposureResponse<Credentials>) in
                            request = exposureResponse.request
                            response = exposureResponse.response
                            data = exposureResponse.data
                            credentials = exposureResponse.value
                            token = credentials?.sessionToken
                            date = credentials?.expiration
                            error = exposureResponse.error
                    }
                }
                
                it("should thrown objectSerialization error with invalid json response") {
                    expect(data).toEventuallyNot(beNil())
                    expect(credentials).toEventually(beNil())
                    expect(error).toEventuallyNot(beNil())
                    expect(error).toEventually(matchError(ExposureError.serialization(reason: ExposureError.SerializationFailureReason.objectSerialization(reason: "Unable to serialize object", json: invalidResponseJson))))
                }
            }
        }
    }
}
