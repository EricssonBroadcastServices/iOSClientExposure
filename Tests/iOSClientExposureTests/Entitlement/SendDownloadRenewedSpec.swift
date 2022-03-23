//
//  SendDownloadRenewedSpec.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-10-22.
//  Copyright © 2020 emp. All rights reserved.
//

import Quick
import Nimble

@testable import iOSClientExposure

class SendDownloadRenewedSpec: QuickSpec {
    override func spec() {
        super.spec()

        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        var env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let assetId = "assetId1_qwerty"
        let sessionToken = SessionToken(value: "token")

        let sendDownloadRenewed = SendDownloadRenewed(assetId: assetId, environment: env, sessionToken: sessionToken)

        describe("SendDownloadRenewedSpec") {
            it("should have headers") {
                expect(sendDownloadRenewed.headers).toNot(beNil())
                expect(sendDownloadRenewed.headers!).to(equal(sessionToken.authorizationHeader))
            }
            
            it("Should fail with invalid endpoint url") {
                let endpoint = "/entitlement/" + assetId + "/downloadrenewed"
                expect(sendDownloadRenewed.endpointUrl).toNot(equal(env.apiUrl+endpoint))
            }
            
            it("should generate a correct endpoint url") {
                env.version = "v2"
                let endpoint = "/entitlement/" + assetId + "/downloadrenewed"
                expect(sendDownloadRenewed.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
        }
    }
}
