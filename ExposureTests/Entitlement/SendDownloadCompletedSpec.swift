//
//  SendDownloadCompletedSpec.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-10-22.
//  Copyright © 2020 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class SendDownloadCompletedSpec: QuickSpec {
    override func spec() {
        super.spec()

        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        var env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let assetId = "assetId1_qwerty"
        let sessionToken = SessionToken(value: "token")

        let sendDownloadComplete = SendDownloadCompleted(assetId: assetId, environment: env, sessionToken: sessionToken)   

        describe("SendDownloadComplete") {
            it("should have headers") {
                expect(sendDownloadComplete.headers).toNot(beNil())
                expect(sendDownloadComplete.headers!).to(equal(sessionToken.authorizationHeader))
            }
            
            it("Should fail with invalid endpoint url") {
                let endpoint = "/entitlement/" + assetId + "/downloadcompleted"
                expect(sendDownloadComplete.endpointUrl).toNot(equal(env.apiUrl+endpoint))
            }
            
            it("should generate a correct endpoint url") {
                env.version = "v2"
                let endpoint = "/entitlement/" + assetId + "/downloadcompleted"
                expect(sendDownloadComplete.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
        }
        
        describe("SendDownloadComplete Response") {
            
            it("should process with valid json") {
                let json = DownloadCompleteJSON.valid()
                
                let result = json.decode(DownloadCompleted.self)
                expect(result).toNot(beNil())
                expect(result?.assetId).toNot(beNil())
                expect(result?.downloadCount).toNot(beNil())
            }
            
            
            it("should init with required keys") {
                let json = DownloadCompleteJSON.requiredKeys()
                let result = json.decode(DownloadCompleted.self)
                expect(result).toNot(beNil())
            }
            
            it("should not init with missing keys response") {
                let json = DownloadCompleteJSON.missingKeys()
                let result = json.decode(DownloadCompleted.self)
                expect(result).to(beNil())
            }
            
            it("should not init with empty response") {
                let json = DownloadCompleteJSON.empty()
                let result = json.decode(DownloadCompleted.self)
                
                expect(result).to(beNil())
            }
        }
    }
}


extension SendDownloadCompletedSpec {
    enum DownloadCompleteJSON {

        static let assetId = "VU-21702_qwerty"
        static let downloadCount = 2
        static let downloads = [DownloadJson.valid()]
        static let changed = "202-10-29T07:00:41Z"
        
        static func valid() -> [String: Any] {
            return [
                "assetId": DownloadCompleteJSON.assetId,
                "downloadCount": DownloadCompleteJSON.downloadCount,
                "downloads": DownloadCompleteJSON.downloads,
                "changed": DownloadCompleteJSON.changed,
            ]
        }
        
        static func requiredKeys() -> [String: Any] {
            return [
                "assetId": DownloadCompleteJSON.assetId,
                "downloadCount": DownloadCompleteJSON.downloadCount
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "downloads": DownloadCompleteJSON.downloads,
                "changed": DownloadCompleteJSON.changed
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}

public enum DownloadJson {
    static let time = "time"
    static let type = "type"
    static let clientIp = "clientIp"
    static let deviceId = "deviceId"
    static let deviceType = "deviceType"
    static let deviceModelId = "deviceModelId"
    static let userId = "userId"
    
    public static func valid() -> [String: Any] {
        return [
            "time": DownloadJson.time,
            "type": DownloadJson.type,
            "clientIp": DownloadJson.clientIp,
            "deviceId": DownloadJson.deviceId,
            "deviceType": DownloadJson.deviceType,
            "deviceModelId": DownloadJson.deviceModelId,
            "userId": DownloadJson.userId,
        ]
    }
    
    public static func empty() -> [String: Any] {
        return [:]
    }
}
