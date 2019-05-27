//
//  PlaybackEntitlementV2Spec.swift
//  Exposure
//
//  Created by Udaya Sri Senarathne on 2019-04-15.
//  Copyright © 2019 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure
class PlaybackEntitlementV2Spec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let formats: [String: Any] = [
            "format": "HLS",
            "drm" : [
                "com.apple.fps" : [
                    "licenseServerUrl" : "licenseServerUrl",
                    "certificateUrl" : "certificateUrl"
                ]
            ],
            "mediaLocator": "https://cache-dev.cdn.ebsd.ericsson.net/L23/000079/000079_enigma.isml/live.mpd?t=2019-04-15T12%3A00%3A00.000"
        ]
        
        let streamInfo: [String: Any] = [
            "live" : false,
            "static" : true,
            "event" : false,
            "start" : 1555329600,
            "channelId" : "channelId",
            "programId" : "programId",
            "end": 15555399
        ]
        
        let bookmarks: [String : Any] = [
            "liveTime" : 10,
            "lastViewedOffset" : 10,
            "lastViewedTime" : 10
        ]
        
        let contractRestrictions: [String: Any] = [
            "airplayEnabled" : true,
            "ffEnabled" : true,
            "maxBitrate" : 20,
            "maxResHeight" : 30,
            "minBitrate": 10,
            "rwEnabled": true,
            "timeshiftEnabled" : true
        ]
        
        let json:[String: Any] = [
            "productId":"productId",
            "entitlementType": "entitlementType",
            "publicationId":"publicationId",
            "playSessionId":"playSessionId",
            "playToken":"playToken",
            "playTokenExpiration": 10,
            "formats":[formats],
            "streamInfo":streamInfo,
            "bookmarks":bookmarks,
            "requestId":"requestId",
            "contractRestrictions" : contractRestrictions
        ]
        
        let requiredJson: [String : Any] = [
            "formats":[formats],
            "playSessionId":"playSessionId",
            "playToken": "playToken",
            "playTokenExpiration" : 10,
            "streamInfo" : streamInfo,
            "productId": "productId",
            "bookmarks":bookmarks,
            "contractRestrictions": contractRestrictions,
        ]
        
        describe("PlaybackEntitlementV2") {
            it("should init with complete json") {
                expect(json.decode(PlayBackEntitlementV2.self)).toNot(beNil())
            }
            
            it("should init with required keys") {
                expect(requiredJson.decode(PlayBackEntitlementV2.self)).toNot(beNil())
            }
            
            it("should not init without required properties") {
                let invalid:[String: Any] = ["invalid":"JSON"]
                
                expect{ try invalid.throwingDecode(PlayBackEntitlementV2.self) }
                    .to(throwError(errorType: DecodingError.self))
            }
            
            it("should not init with empty json") {
                let empty:[String: Any] = [:]
                
                expect{ try empty.throwingDecode(PlayBackEntitlementV2.self) }
                    .to(throwError(errorType: DecodingError.self))
            }
            
            it("should not create invalid StreamInfo") {
                let result = requiredJson.decode(PlayBackEntitlementV2.self)
                
                expect(result).toNot(beNil())
                expect(result?.streamInfo).notTo(beNil())
            }
            
            it("Should encode and decode properly") {
                let entitlement = json.decode(PlayBackEntitlementV2.self)
                expect(entitlement).toNot(beNil())
                
                let encoded = try? JSONEncoder().encode(entitlement!)
                expect(encoded).toNot(beNil())
                
                let decoded = try? JSONDecoder().decode(PlayBackEntitlementV2.self, from: encoded!)
                expect(decoded).toNot(beNil())
                
                expect(decoded!.requestId).to(equal(entitlement!.requestId))
                
                expect(decoded!.bookmarks?.lastViewedOffset).to(equal(entitlement!.bookmarks?.lastViewedOffset))
                expect(decoded!.bookmarks?.liveTime).to(equal(entitlement!.bookmarks?.liveTime))
                expect(decoded!.bookmarks?.lastViewedTime).to(equal(entitlement!.bookmarks?.lastViewedTime))
                expect(decoded!.contractRestrictions?.airplayEnabled).to(equal(entitlement!.contractRestrictions?.airplayEnabled))
                
                
                expect(decoded!.contractRestrictions?.ffEnabled).to(equal(entitlement!.contractRestrictions?.ffEnabled))
                
                expect(decoded!.contractRestrictions?.maxBitrate).to(equal(entitlement!.contractRestrictions?.maxBitrate))
                
                
                expect(decoded!.contractRestrictions?.maxResHeight).to(equal(entitlement!.contractRestrictions?.maxResHeight))
                
                expect(decoded!.contractRestrictions?.minBitrate).to(equal(entitlement!.contractRestrictions?.minBitrate))
                expect(decoded!.contractRestrictions?.rwEnabled).to(equal(entitlement!.contractRestrictions?.rwEnabled))
                expect(decoded!.contractRestrictions?.timeshiftEnabled).to(equal(entitlement!.contractRestrictions?.timeshiftEnabled))
                
                
                expect(decoded!.entitlementType).to(equal(entitlement!.entitlementType))
                
                // Formats
                /* expect(decoded!.formats?.first?.format).to(equal(entitlement!.formats?.first?.format))
                 expect(decoded!.formats?.first?.mediaLocator).to(equal(entitlement!.formats?.first?.mediaLocator))
                 expect(decoded!.formats?.first?.fairplay.first?.secondaryMediaLocator).to(equal(entitlement!.formats?.first?.fairplay.first?.secondaryMediaLocator))
                 expect(decoded!.formats?.first?.fairplay.first?.certificateUrl).to(equal(entitlement!.formats?.first?.fairplay.first?.certificateUrl))
                 expect(decoded!.formats?.first?.fairplay.first?.licenseAcquisitionUrl).to(equal(entitlement!.formats?.first?.fairplay.first?.licenseAcquisitionUrl))
                 expect(decoded!.formats?.first?.fairplay.first?.licenseServerUrl).to(equal(entitlement!.formats?.first?.fairplay.first?.licenseServerUrl)) */
                
                expect(decoded!.playToken).to(equal(entitlement!.playToken))
                expect(decoded!.playTokenExpiration).to(equal(entitlement!.playTokenExpiration))
                expect(decoded!.productId).to(equal(entitlement!.productId))
                expect(decoded!.publicationId).to(equal(entitlement!.publicationId))
                
                // StreamInfo
                expect(decoded!.streamInfo.channelId).to(equal(entitlement!.streamInfo.channelId))
                expect(decoded!.streamInfo.end).to(equal(entitlement!.streamInfo.end))
                expect(decoded!.streamInfo.staticProgram).to(equal(entitlement!.streamInfo.staticProgram))
                expect(decoded!.streamInfo.live).to(equal(entitlement!.streamInfo.live))
                expect(decoded!.streamInfo.event).to(equal(entitlement!.streamInfo.event))
                expect(decoded!.streamInfo.programId).to(equal(entitlement!.streamInfo.programId))
                expect(decoded!.streamInfo.start).to(equal(entitlement!.streamInfo.start))
               
            }
        }
    }
    
}
