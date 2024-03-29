//
//  PlayVodSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-24.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import iOSClientExposure

class PlayVodSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let assetId = "assetId1_qwerty"
        let sessionToken = SessionToken(value: "token")
        
        let playVod = Entitlement(environment: env,
                                  sessionToken: sessionToken)
            .vod(assetId: assetId)
            .use(drm: "UNENCRYPTED")
            .use(format: "HLS")
        
        describe("PlayVod") {
            it("should have headers") {
                expect(playVod.headers).toNot(beNil())
                expect(playVod.headers!).to(equal(sessionToken.authorizationHeader))
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/entitlement/" + assetId + "/play"
                expect(playVod.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should record DRM and format") {
                let drm = playVod.drm
                let format = playVod.format
                
                expect(drm).to(equal("UNENCRYPTED"))
                expect(format).to(equal("HLS"))
            }
        }
    }
}
