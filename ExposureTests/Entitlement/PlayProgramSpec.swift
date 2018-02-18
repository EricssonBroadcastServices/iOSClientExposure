//
//  PlayCatchupSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class PlayProgramSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let channelId = "channel1_qwerty"
        let programId = "program1_qwerty"
        
        let endpoint = "/entitlement/channel/" + channelId + "/program/" + programId + "/play"
        
        let sessionToken = SessionToken(value: "token")
        
        let entitlement = Entitlement(environment: env,
                                      sessionToken: sessionToken)
        let play = entitlement
            .program(programId: programId, channelId: channelId)
            .use(drm: "UNENCRYPTED")
            .use(format: "HLS")
        
        describe("Catchup") {
            it("should have headers") {
                expect(play.headers).toNot(beNil())
                expect(play.headers!).to(equal(sessionToken.authorizationHeader))
            }
            
            it("should generate a correct endpoint url") {
                expect(play.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should record DRM and format") {
                let drm = play.drm
                let format = play.format
                
                expect(drm).to(equal("UNENCRYPTED"))
                expect(format).to(equal("HLS"))
            }
            
            it("should transform PlayLive to PlayCatchup") {
                let transformed = entitlement
                    .live(channelId: channelId)
                    .program(programId: programId)
                
                expect(transformed.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
        }
    }
}
