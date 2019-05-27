//
//  PlayEnigmaAssetSpec.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2019-05-27.
//  Copyright © 2019 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class PlayEnigmaAssetSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net/"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        var env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        env.version = "v2"
        let assetId = "assetId1_qwerty"
        let sessionToken = SessionToken(value: "token")
        
        let playEnigmaAsset = Entitlement(environment: env,
                                  sessionToken: sessionToken)
            .enigmaAsset(assetId: assetId)
        
        describe("PlayEnigmaAsset") {
            it("should have headers") {
                expect(playEnigmaAsset.headers).toNot(beNil())
                expect(playEnigmaAsset.headers!).to(equal(sessionToken.authorizationHeader))
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/entitlement/" + assetId + "/play"
                expect(playEnigmaAsset.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
        }
    }

}
