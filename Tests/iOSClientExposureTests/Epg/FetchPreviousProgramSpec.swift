//
//  FetchPreviousProgramSpec.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2019-05-27.
//  Copyright © 2019 emp. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import iOSClientExposure

class FetchPreviousProgramSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        
        let programId = "next"
        let fetch = FetchEpg(environment: env)
        
        let program = fetch.previous(programId: programId)
        describe("Program") {
            it("should have no headers") {
                expect(program.headers).to(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/epg/program/" + programId + "/previous"
                expect(program.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should have no paramters") {
                let params = program.parameters
                expect(params?["onlyPublished"]).to(be(true))
            }
        }
    }
}
