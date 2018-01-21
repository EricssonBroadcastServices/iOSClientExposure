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
        
        let edrmJson:[String: Codable] = [
            "ownerId":"owner",
            "userToken":"userToken",
            "requestUrl":"requestUrl",
            "adParameter":"adParameter"
        ]
        let fairplayJson:[String: Codable] = [
            "secondaryMediaLocator":"secondaryMediaLocator",
            "certificateUrl":"certificateUrl",
            "licenseAcquisitionUrl":"licenseAcquisitionUrl"
        ]
        let json:[String: Codable] = [
            "playToken":"playToken",
            "edrmConfig":edrmJson,
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
            "productId":"productId"
        ]
        
        let requiredJson:[String: Codable] = [
            "playToken":"playToken",
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
                let invalid:[String: Codable] = ["invalid":"JSON"]
                
                expect{ try invalid.throwingDecode(PlaybackEntitlement.self) }
                    .to(throwError(errorType: DecodingError.self))
            }
            
            it("should not init with empty json") {
                let empty:[String: Codable] = [:]
                
                expect{ try empty.throwingDecode(PlaybackEntitlement.self) }
                    .to(throwError(errorType: DecodingError.self))
            }
            
            it("should not create invalid EDRMConfiguration") {
                let result = requiredJson.decode(PlaybackEntitlement.self)
                
                expect(result).toNot(beNil())
                expect(result?.edrm).to(beNil())
            }
            
            it("should not create invalid FairplayConfiguration") {
                let result = requiredJson.decode(PlaybackEntitlement.self)
                
                expect(result).toNot(beNil())
                expect(result?.fairplay).to(beNil())
            }
        }
    }
}
