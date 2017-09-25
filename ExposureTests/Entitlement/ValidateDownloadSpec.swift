//
//  ValidateDownloadSpec.swift
//  ExposureTests
//
//  Created by Fredrik Sjöberg on 2017-09-25.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class ValidateDownloadSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let assetId = "assetId1_qwerty"
        let sessionToken = SessionToken(value: "token")
        
        let request = Entitlement(environment: env,
                                  sessionToken: sessionToken)
            .validate(downloadId: assetId)
            .use(drm: .unencrypted)
            .use(format: .hls)
        
        describe("ValidateDownload") {
            it("should have headers") {
                expect(request.headers).toNot(beNil())
                expect(request.headers!).to(equal(sessionToken.authorizationHeader))
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/download/" + assetId
                expect(request.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let json = PlayRequest().toJSON()
                expect(request.parameters.count).to(equal(json.count))
            }
            
            it("should record DRM and format") {
                let drm = request.drm
                let format = request.format
                
                expect(drm.rawValue).to(equal(PlayRequest.DRM.unencrypted.rawValue))
                expect(format.rawValue).to(equal(PlayRequest.Format.hls.rawValue))
            }
        }
        
        describe("DownloadValidation") {
            it("should process with valid json") {
                let json: [String: Any] = [
                    "status":"SUCCESS",
                    "paymentDone":false,
                    "bitrates": [
                        [
                            "bitrate": 120000,
                            "size": 200000
                        ]
                    ],
                    "downloadMaxSecondsAfterPlay": 100,
                    "downloadMaxSecondsAfterDownload": 200
                ]
                
                let result = DownloadValidation(json: json)
                
                expect(result).toNot(beNil())
                expect(result?.status).toNot(beNil())
                expect(result?.paymentDone).toNot(beNil())
            }
            
            it("should fail with invalid json") {
                let json: [String: Any] = [
                    "WRONG_KEY":"SUCCESS",
                    "OTHER_MISTAKE":false
                ]
                
                let result = DownloadValidation(json: json)
                
                expect(result).to(beNil())
            }
        }
    }
}
