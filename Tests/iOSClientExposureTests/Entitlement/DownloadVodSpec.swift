//
//  DownloadVodSpec.swift
//  Exposure
//
//  Created by Viktor Gardart on 2017-09-18.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import iOSClientExposure

class DownloadVodSpec: QuickSpec {
    override func spec() {
        super.spec()

        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        var env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        env.version = "v2"
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
                let endpoint = "/entitlement/" + assetId + "/download"
                expect(downloadVod.endpointUrl).to(equal(env.apiUrl+endpoint))
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

