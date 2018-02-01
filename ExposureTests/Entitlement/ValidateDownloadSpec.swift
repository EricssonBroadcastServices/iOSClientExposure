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
            .use(drm: "UNENCRYPTED")
            .use(format: "HLS")
        
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
                
                expect(drm).to(equal("UNENCRYPTED"))
                expect(format).to(equal("HLS"))
            }
        }
        
        describe("DownloadValidation") {
            it("should process with valid json") {
                let bitrate: [String: Codable] = [
                    "bitrate": 120000,
                    "size": 200000
                ]
                
                let json: [String: Codable] = [
                    "status":"SUCCESS",
                    "paymentDone":false,
                    "bitrates": [bitrate],
                    "downloadMaxSecondsAfterPlay": 100,
                    "downloadMaxSecondsAfterDownload": 200
                ]
                
                let result = json.decode(DownloadValidation.self)
                
                expect(result).toNot(beNil())
                expect(result?.status).to(equal("SUCCESS"))
                expect(result?.paymentDone).to(equal(false))
                expect(result?.downloadMaxSecondsAfterPlay).to(equal(100))
                expect(result?.downloadMaxSecondsAfterDownload).to(equal(200))
                expect(bitrate.decode(DownloadValidation.Bitrate.self)).toNot(beNil())
                expect(result?.bitrates?.first?.bitrate).to(equal(120000))
                expect(result?.bitrates?.first?.size).to(equal(200000))
                
            }
            
            it("should fail with invalid json") {
                let json: [String: Codable] = [
                    "WRONG_KEY":"SUCCESS",
                    "OTHER_MISTAKE":false
                ]
                
                expect{ try json.throwingDecode(DownloadValidation.self) }
                    .to(throwError(errorType: DecodingError.self))
            }
        }
    }
}
