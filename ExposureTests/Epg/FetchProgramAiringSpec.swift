//
//  FetchProgramAiringSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-09-07.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import Exposure

class FetchProgramAiringSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        
        let channelId = "first"
        let programId = "second"
        let fetch = FetchEpg(environment: env)
        
        
        describe("Program Airing") {
            let airing = fetch.airingFor(programId: programId, channelId: channelId)
            
            it("should have no headers") {
                expect(airing.headers).to(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/epg/" + channelId + "/program/" + programId + "/airing"
                expect(airing.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should have no paramters") {
                expect(airing.parameters).to(beNil())
            }
        }
    }
}
