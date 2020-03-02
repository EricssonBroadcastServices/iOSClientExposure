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
        
        let fetchLastViewedOffset = FetchContinueTVShow(assetId: assetId, environment: env, sessionToken: sessionToken)
        
        describe("Basics") {
            
            it("should have auth token headers") {
                expect(fetchLastViewedOffset.headers).toNot(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/userplayhistory/continue/tvshow/"+assetId
                expect(fetchLastViewedOffset.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should not generate parameters") {
                let params = fetchLastViewedOffset.parameters

                expect(params.count).to(equal(0))
            }
        }
    }
}
