//
//  PlaybackEntitlementSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-24.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class PlaybackEntitlementSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        let fairplayJson:[String: Any] = [
            "secondaryMediaLocator":"secondaryMediaLocator",
            "certificateUrl":"certificateUrl",
            "licenseAcquisitionUrl":"licenseAcquisitionUrl",
            "licenseServerUrl": "licenseServerUrl"
        ]
        let json:[String: Any] = [
            "assetId":"assetId",
            "accountId":"accountId",
            "audioOnly":true,
            "playToken":"playToken",
            "fairplayConfig":fairplayJson,
            "mediaLocator":"mediaLocator",
            "licenseExpiration":"licenseExpiration",
            "licenseExpirationReason":"NOT_ENTITLED",
            "licenseActivation":"licenseActivation",
            "playTokenExpiration":"playTokenExpiration",
            "entitlementType":"TVOD",
            "live":false,
            "playSessionId":"playSessionId",
            "ffEnabled":false,
            "timeshiftEnabled":false,
            "rwEnabled":false,
            "minBitrate":10,
            "maxBitrate":20,
            "maxResHeight":30,
            "airplayBlocked":false,
            "mdnRequestRouterUrl":"mdnRequestRouterUrl",
            "lastViewedOffset":10,
            "lastViewedTime":10,
            "liveTime":10,
            "productId":"productId"
        ]
        
        let requiredJson:[String: Any] = [
            "mediaLocator":"mediaLocator",
            "playTokenExpiration":"playTokenExpiration",
            "playSessionId":"playSessionId",
            "live":false,
            "ffEnabled":false,
            "timeshiftEnabled":false,
            "rwEnabled":false,
            "airplayBlocked":false,
        ]
        
        describe("PlaybackEntitlement") {
            it("should init with complete json") {
                expect(json.decode(PlaybackEntitlement.self)).toNot(beNil())
            }
            
            it("should init with required keys") {
                expect(requiredJson.decode(PlaybackEntitlement.self)).toNot(beNil())
            }
            
            it("should not init without required properties") {
                let invalid:[String: Any] = ["invalid":"JSON"]
                
                expect{ try invalid.throwingDecode(PlaybackEntitlement.self) }
                    .to(throwError(errorType: DecodingError.self))
            }
            
            it("should not init with empty json") {
                let empty:[String: Any] = [:]
                
                expect{ try empty.throwingDecode(PlaybackEntitlement.self) }
                    .to(throwError(errorType: DecodingError.self))
            }
            
            it("should not create invalid FairplayConfiguration") {
                let result = requiredJson.decode(PlaybackEntitlement.self)
                
                expect(result).toNot(beNil())
                expect(result?.fairplay).to(beNil())
            }
            
            it("Should encode and decode properly") {
                let entitlement = json.decode(PlaybackEntitlement.self)
                expect(entitlement).toNot(beNil())
                
                let encoded = try? JSONEncoder().encode(entitlement!)
                expect(encoded).toNot(beNil())
                
                let decoded = try? JSONDecoder().decode(PlaybackEntitlement.self, from: encoded!)
                expect(decoded).toNot(beNil())
                
                expect(decoded!.playTokenExpiration).to(equal(entitlement!.playTokenExpiration))
                expect(decoded!.mediaLocator).to(equal(entitlement!.mediaLocator))
                expect(decoded!.playSessionId).to(equal(entitlement!.playSessionId))
                expect(decoded!.live).to(equal(entitlement!.live))
                expect(decoded!.ffEnabled).to(equal(entitlement!.ffEnabled))
                expect(decoded!.timeshiftEnabled).to(equal(entitlement!.timeshiftEnabled))
                expect(decoded!.rwEnabled).to(equal(entitlement!.rwEnabled))
                expect(decoded!.airplayBlocked).to(equal(entitlement!.airplayBlocked))
                expect(decoded!.playToken).to(equal(entitlement!.playToken))
                expect(decoded!.fairplay?.secondaryMediaLocator).to(equal(entitlement!.fairplay?.secondaryMediaLocator))
                expect(decoded!.fairplay?.certificateUrl).to(equal(entitlement!.fairplay?.certificateUrl))
                expect(decoded!.fairplay?.licenseAcquisitionUrl).to(equal(entitlement!.fairplay?.licenseAcquisitionUrl))
                expect(decoded!.licenseExpiration).to(equal(entitlement!.licenseExpiration))
                expect(decoded!.licenseExpirationReason).to(equal(entitlement!.licenseExpirationReason))
                expect(decoded!.licenseActivation).to(equal(entitlement!.licenseActivation))
                expect(decoded!.entitlementType).to(equal(entitlement!.entitlementType))
                expect(decoded!.minBitrate).to(equal(entitlement!.minBitrate))
                expect(decoded!.maxBitrate).to(equal(entitlement!.maxBitrate))
                expect(decoded!.maxResHeight).to(equal(entitlement!.maxResHeight))
                expect(decoded!.mdnRequestRouterUrl).to(equal(entitlement!.mdnRequestRouterUrl))
                expect(decoded!.lastViewedOffset).to(equal(entitlement!.lastViewedOffset))
                expect(decoded!.lastViewedTime).to(equal(entitlement!.lastViewedTime))
                expect(decoded!.liveTime).to(equal(entitlement!.liveTime))
                expect(decoded!.productId).to(equal(entitlement!.productId))
            }
        }
    }
}
