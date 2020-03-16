//
//  FetchContinueTVShowSpec.swift
//  Exposure
//
//  Created by Johnny Sundblom on 2020-03-02.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import Exposure

class FetchContinueTVShowSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let sessionToken = SessionToken(value: "token")
        let assetId = "123"
        
        let fetchContinueTVShow = FetchContinueTVShow(assetId: assetId, environment: env, sessionToken: sessionToken)
        let headers = fetchContinueTVShow.headers
        let endpointUrl = fetchContinueTVShow.endpointUrl
        let parameters = fetchContinueTVShow.parameters
        
        describe("Basics") {
            
            it("should have auth token headers") {
                expect(headers).toNot(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/userplayhistory/continue/tvshow/\(assetId)"
                expect(endpointUrl).to(equal("\(env.apiUrl)\(endpoint)"))
            }
            
            it("should not generate parameters") {
                expect(parameters.count).to(equal(0))
            }
        }
    }
}
