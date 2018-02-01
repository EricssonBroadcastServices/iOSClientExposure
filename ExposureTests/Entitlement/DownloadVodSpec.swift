//
//  DownloadVodSpec.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-09-18.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class DownloadVodSpec: QuickSpec {
    override func spec() {
        super.spec()

        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let assetId = "assetId1_qwerty"
        let sessionToken = SessionToken(value: "token")

        let downloadVod = Entitlement(environment: env,
                                      sessionToken: sessionToken)
            .download(assetId: assetId)
            .use(drm: "UNENCRYPTED")
            .use(format: "HLS")

        describe("DownloadVod") {
            it("should have headers") {
                expect(downloadVod.headers).toNot(beNil())
                expect(downloadVod.headers!).to(equal(sessionToken.authorizationHeader))
            }

            it("should generate a correct endpoint url") {
                let endpoint = "/download/" + assetId
                expect(downloadVod.endpointUrl).to(equal(env.apiUrl+endpoint))
            }

            it("should generate paramters") {
                let json = PlayRequest().toJSON()
                expect(downloadVod.parameters.count).to(equal(json.count))
            }

            it("should record DRM and format") {
                let drm = downloadVod.drm
                let format = downloadVod.format

                expect(drm).to(equal("UNENCRYPTED"))
                expect(format).to(equal("HLS"))
            }
        }
    }
}

