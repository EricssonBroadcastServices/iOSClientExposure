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
        
        describe("PlaybackEntitlement") {
            it("should init with complete json") {
                let edrmJson:[String: Any] = [
                    "ownerId":"owner",
                    "userToken":"userToken",
                    "requestUrl":"requestUrl",
                    "adParameter":"adParameter"
                ]
                let fairplayJson:[String: Any] = [
                    "secondaryMediaLocator":"secondaryMediaLocator",
                    "certificateUrl":"certificateUrl",
                    "licenseAcquisitionUrl":"licenseAcquisitionUrl"
                ]
                let json:[String: Any] = [
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
                    "mdnRequestRouterUrl":"mdnRequestRouterUrl"
                ]
                
                let entitlement = PlaybackEntitlement(json: json)
                
                expect(entitlement).toNot(beNil())
            }
            
            it("should not create invalid EDRMConfiguration") {
                let entitlement = PlaybackEntitlement(json: [:])
                
                expect(entitlement).toNot(beNil())
                expect(entitlement?.edrm).to(beNil())
            }
            
            it("should not create invalid FairplayConfiguration") {
                let entitlement = PlaybackEntitlement(json: [:])
                
                expect(entitlement).toNot(beNil())
                expect(entitlement?.fairplay).to(beNil())
            }
        }
        
        describe("EntitlementType") {
            it("should convert to typed") {
                let tvod = PlaybackEntitlement.EntitlementType(string: "TVOD")
                let svod = PlaybackEntitlement.EntitlementType(string: "SVOD")
                let fvod = PlaybackEntitlement.EntitlementType(string: "FVOD")
                let other = PlaybackEntitlement.EntitlementType(string: "Custom type")
                
                expect(self.test(entitlementType: tvod, against: .tvod)).to(beTrue())
                expect(self.test(entitlementType: svod, against: .svod)).to(beTrue())
                expect(self.test(entitlementType: fvod, against: .fvod)).to(beTrue())
                expect(self.test(entitlementType: other, against: .other(type: "Custom type"))).to(beTrue())
            }
            
            it("should not init with nil string") {
                expect(PlaybackEntitlement.EntitlementType(string: nil)).to(beNil())
            }
        }
        
        describe("ExpirationReason") {
            
            it("should convert to typed") {
                expect(self.test(expirationReason: PlaybackEntitlement.ExpirationReason(string: "SUCCESS"), against: .success)).to(beTrue())
                expect(self.test(expirationReason: PlaybackEntitlement.ExpirationReason(string: "NOT_ENTITLED"), against: .notEntitled)).to(beTrue())
                expect(self.test(expirationReason: PlaybackEntitlement.ExpirationReason(string: "GEO_BLOCKED"), against: .geoBlocked)).to(beTrue())
                expect(self.test(expirationReason: PlaybackEntitlement.ExpirationReason(string: "DOWNLOAD_BLOCKED"), against: .downloadBlocked)).to(beTrue())
                expect(self.test(expirationReason: PlaybackEntitlement.ExpirationReason(string: "DEVICE_BLOCKED"), against: .deviceBlocked)).to(beTrue())
                expect(self.test(expirationReason: PlaybackEntitlement.ExpirationReason(string: "LICENSE_EXPIRED"), against: .licenseExpired)).to(beTrue())
                expect(self.test(expirationReason: PlaybackEntitlement.ExpirationReason(string: "NOT_AVAILABLE_IN_FORMAT"), against: .notAvailableInFormat)).to(beTrue())
                expect(self.test(expirationReason: PlaybackEntitlement.ExpirationReason(string: "CONCURRENT_STREAMS_LIMIT_REACHED"), against: .concurrentStreamsLimitReached)).to(beTrue())
                expect(self.test(expirationReason: PlaybackEntitlement.ExpirationReason(string: "NOT_ENABLED"), against: .notEnabled)).to(beTrue())
                expect(self.test(expirationReason: PlaybackEntitlement.ExpirationReason(string: "GAP_IN_EPG"), against: .gapInEPG)).to(beTrue())
                expect(self.test(expirationReason: PlaybackEntitlement.ExpirationReason(string: "EPG_PLAY_MAX_HOURS"), against: .epgPlayMaxHours)).to(beTrue())
                expect(self.test(expirationReason: PlaybackEntitlement.ExpirationReason(string: "Some Reason"), against: .other(reason:"Some Reason"))).to(beTrue())
            }
            
            it("should not init with nil string") {
                expect(PlaybackEntitlement.EntitlementType(string: nil)).to(beNil())
            }
        }
    }
    
    func test(entitlementType: PlaybackEntitlement.EntitlementType, against: PlaybackEntitlement.EntitlementType) -> Bool {
        switch (entitlementType, against) {
        case (.svod, .svod): return true
        case (.tvod, .tvod): return true
        case (.fvod, .fvod): return true
        case (.other(let first), .other(let second)): return first == second
        default: return false
        }
    }
    
    func test(expirationReason: PlaybackEntitlement.ExpirationReason, against: PlaybackEntitlement.ExpirationReason) -> Bool {
        switch (expirationReason, against) {
        case (.success, .success): return true
        case (.notEntitled, .notEntitled): return true
        case (.geoBlocked, .geoBlocked): return true
        case (.downloadBlocked, .downloadBlocked): return true
        case (.deviceBlocked, .deviceBlocked): return true
        case (.licenseExpired, .licenseExpired): return true
        case (.notAvailableInFormat, .notAvailableInFormat): return true
        case (.concurrentStreamsLimitReached, .concurrentStreamsLimitReached): return true
        case (.notEnabled, .notEnabled): return true
        case (.gapInEPG, .gapInEPG): return true
        case (.epgPlayMaxHours, .epgPlayMaxHours): return true
        case (.other(let first), .other(let second)): return first == second
        default: return false
        }
    }
}
