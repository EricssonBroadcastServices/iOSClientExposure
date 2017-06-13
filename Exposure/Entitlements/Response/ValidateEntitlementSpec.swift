//
//  ValidateEntitlementSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class ValidateEntitlementSpec: QuickSpec {
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
            .use(drm: .unencrypted)
            .use(format: .hls)
        
        describe("PlayVod") {
            it("should have headers") {
                expect(playVod.headers).toNot(beNil())
                expect(playVod.headers!).to(equal(sessionToken.authorizationHeader))
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/entitlement/" + assetId + "/play"
                expect(playVod.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let json = PlayRequest().toJSON()
                expect(playVod.parameters.count).to(equal(json.count))
            }
            
            it("should record DRM and format") {
                let drm = playVod.drm
                let format = playVod.format
                
                expect(drm.rawValue).to(equal(PlayRequest.DRM.unencrypted.rawValue))
                expect(format.rawValue).to(equal(PlayRequest.Format.hls.rawValue))
            }
        }
    }
}
