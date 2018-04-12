//
//  ExposureApiSpec.swift
//  Exposure-iOS
//
//  Created by Fredrik Sjöberg on 2018-04-11.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import Exposure

class ExposureApiSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let token = SessionToken(value: "token")
        let query = "onlyPublished=true&includeUserData=true&fieldSet=ALL"
        let request = ExposureApi<LastViewedList>(environment: env, endpoint: "/userplayhistory/lastviewed", query: query, sessionToken: token)
        
        describe("Basics") {
            
            it("should have headers") {
                expect(request.headers).toNot(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/userplayhistory/lastviewed"
                expect(request.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let params = request.parameters
                expect(params).toNot(beNil())
                
                expect(params!.count).to(equal(3))
                
                expect(params!["onlyPublished"]).toNot(beNil())
                expect(params!["includeUserData"]).toNot(beNil())
                expect(params!["fieldSet"]).toNot(beNil())
            }
        }
    }
}
