//
//  GetAllDownloadsSpec.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2020-10-22.
//  Copyright © 2020 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class GetAllDownloadsSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        var env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let sessionToken = SessionToken(value: "token")
        
        let deleteDownload = GetAllDownloads(environment: env, sessionToken: sessionToken)
        
        describe("GetAllDownloadsSpec") {
            it("should have headers") {
                expect(deleteDownload.headers).toNot(beNil())
                expect(deleteDownload.headers!).to(equal(sessionToken.authorizationHeader))
            }
            
            it("Should fail with invalid endpoint url") {
                let endpoint = "/entitlement/downloads"
                expect(deleteDownload.endpointUrl).toNot(equal(env.apiUrl+endpoint))
            }
            
            it("should generate a correct endpoint url") {
                env.version = "v2"
                let endpoint = "/entitlement/downloads"
                expect(deleteDownload.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
        }
        
        describe("GetAllDownloadsComplete Response") {
            
            it("should process with valid json") {
                let json = AllDownloadsJson.valid()
                let result = json.decode(AllDownloads.self)
                expect(result).toNot(beNil())
                expect(result?.accountId).toNot(beNil())
                expect(result?.assets).toNot(beNil())
            }
            
            
            it("should init with required keys") {
                let json = AllDownloadsJson.requiredKeys()
                let result = json.decode(AllDownloads.self)
                expect(result).toNot(beNil())
            }
        }
    }
}

extension GetAllDownloadsSpec {
    enum AllDownloadsJson {
        
        static let accountId = "accountId"
        static let assets = [DownloadedAssetsJson.valid()]
        
        static func valid() -> [String: Any] {
            return [
                "accountId": AllDownloadsJson.accountId,
                "assets": AllDownloadsJson.assets
            ]
        }
        
        static func requiredKeys() -> [String: Any] {
            return [
                "accountId": AllDownloadsJson.accountId,
                "assets": AllDownloadsJson.assets
            ]
        }
    }
    
    
    enum DownloadedAssetsJson {
        
        static let assetId = "assetId"
        static let downloadCount = 2
        static let downloads = [DownloadJson.valid()]
        static let changed = "message"
        
        static func valid() -> [String: Any] {
            return [
                "assetId": DownloadedAssetsJson.assetId,
                "downloadCount": DownloadedAssetsJson.downloadCount,
                "downloads": DownloadedAssetsJson.downloads,
                "changed": DownloadedAssetsJson.changed,
            ]
        }
        
        static func requiredKeys() -> [String: Any] {
            return [
                "assetId": DownloadedAssetsJson.assetId,
                "downloadCount": DownloadedAssetsJson.downloadCount,
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "downloads": DownloadedAssetsJson.downloads,
                "changed": DownloadedAssetsJson.changed
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
