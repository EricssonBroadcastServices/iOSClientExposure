//
//  DeleteDownloadSpec.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-10-22.
//  Copyright © 2020 emp. All rights reserved.
//

import Quick
import Nimble

@testable import iOSClientExposure

class DeleteDownloadSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        var env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let assetId = "assetId1_qwerty"
        let sessionToken = SessionToken(value: "token")
        
        let deleteDownload = DeleteDownload(assetId: assetId, environment: env, sessionToken: sessionToken)
        
        describe("DeleteDownloadSpec") {
            it("should have headers") {
                expect(deleteDownload.headers).toNot(beNil())
                expect(deleteDownload.headers!).to(equal(sessionToken.authorizationHeader))
            }
            
            it("Should fail with invalid endpoint url") {
                let endpoint = "/entitlement/" + assetId + "/downloads"
                expect(deleteDownload.endpointUrl).toNot(equal(env.apiUrl+endpoint))
            }
            
            it("should generate a correct endpoint url") {
                env.version = "v2"
                let endpoint = "/entitlement/" + assetId + "/downloads"
                expect(deleteDownload.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
        }
        
        describe("DeleteDownloadComplete Response") {
            
            it("should process with valid json") {
                let json = DeleteDownloadCompletedJson.valid()
                let result = json.decode(DeleteDownloadCompleted.self)
                expect(result).toNot(beNil())
                expect(result?.message).toNot(beNil())
            }
            
            
            it("should init with required keys") {
                let json = DeleteDownloadCompletedJson.requiredKeys()
                let result = json.decode(DeleteDownloadCompleted.self)
                expect(result).toNot(beNil())
            }
        }
    }
}

extension DeleteDownloadSpec {
    enum DeleteDownloadCompletedJson {
        
        static let message = "message"
        
        static func valid() -> [String: Any] {
            return [
                "message": DeleteDownloadCompletedJson.message
            ]
        }
        
        static func requiredKeys() -> [String: Any] {
            return [
                "message": DeleteDownloadCompletedJson.message,
            ]
        }
    }
    
}
