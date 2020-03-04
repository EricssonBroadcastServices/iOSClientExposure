//
//  FetchUserDetailsSpec.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-01-07.
//  Copyright © 2020 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class FetchUserDetailsSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        var env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let sessionToken = SessionToken(value: "token")
        
        // env.version = "v2"
        
        let userDetails = FetchUserDetails(environment: env, sessionToken: sessionToken)
        
        describe("UserDetails") {
            it("should have headers") {
                expect(userDetails.headers).toNot(beNil())
                expect(userDetails.headers!).to(equal(sessionToken.authorizationHeader))
            }
            
            it("Should fail with invalid endpoint url") {
                let endpoint = "/user/details/"
                expect(userDetails.endpointUrl).toNot(equal(env.apiUrl+endpoint))
            }
            
            it("should generate a correct endpoint url") {
                env.version = "v2"
                let endpoint = "/user/details/"
                expect(userDetails.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
        }
        
        describe("UserDetails Response") {
            it("should process with valid json") {
                let json: [String : Any] = [
                    "displayName":"",
                    "language":"",
                    "defaultLanguage": ""
                    ]
                
                let result = json.decode(UserDetails.self)
                
                expect(result).toNot(beNil())
            }
            
            it("should not fail with invalid json") {
                let json: [String: Any] = [
                    "displayName":"",
                    "language":NSNull(),
                    "defaultLanguage":""
                ]
                
                expect{ try json.throwingDecode(UserDetails.self) }
                    .toNot(throwError(errorType: DecodingError.self))
            }
        }
        
        
    }
}
