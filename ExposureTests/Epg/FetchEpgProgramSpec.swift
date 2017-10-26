//
//  FetchEpgProgramSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay

@testable import Exposure

class FetchEpgProgramSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        
        let channelId = "first"
        let programId = "second"
        let fetch = FetchEpg(environment: env)
        
        let program = fetch.channel(id: channelId, programId: programId)
        describe("Program") {
            it("should have no headers") {
                expect(program.headers).to(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/epg/" + channelId + "/program/" + programId
                expect(program.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let params = program
                    .filter(onlyPublished: true)
                    .parameters
                
                expect(params.count).to(equal(1))
                expect(params["onlyPublished"]).toNot(beNil())
            }
        }
    }
}
