//
//  AssetRightsSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-16.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class AssetRightsSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let value = AssetRights(json: AssetRightsJSON.valid())
                
                expect(value).toNot(beNil())
                expect(value!.minBitrate).toNot(beNil())
                expect(value!.maxBitrate).toNot(beNil())
                expect(value!.maxResWidth).toNot(beNil())
                expect(value!.maxResHeight).toNot(beNil())
                expect(value!.playCount).toNot(beNil())
                expect(value!.maxFileSize).toNot(beNil())
                expect(value!.activation).toNot(beNil())
                expect(value!.expiration).toNot(beNil())
                expect(value!.maxAds).toNot(beNil())
                expect(value!.wifiBlocked).toNot(beNil())
                expect(value!.threeGBlocked).toNot(beNil())
                expect(value!.fourGBlocked).toNot(beNil())
                expect(value!.HDMIBlocked).toNot(beNil())
                expect(value!.airplayBlocked).toNot(beNil())
                expect(value!.downloadBlocked).toNot(beNil())
                expect(value!.streamingBlocked).toNot(beNil())
                expect(value!.analyticsEnabled).toNot(beNil())
                expect(value!.sessionShiftEnabled).toNot(beNil())
                expect(value!.rwEnabled).toNot(beNil())
                expect(value!.ffEnabled).toNot(beNil())
                expect(value!.amcDebugLogEnabled).toNot(beNil())
                expect(value!.locationEnabled).toNot(beNil())
                expect(value!.minPlayPosition).toNot(beNil())
                expect(value!.maxPlayPosition).toNot(beNil())
                expect(value!.jailbrokenBlocked).toNot(beNil())
                expect(value!.downloadMaxSecondsAfterDownload).toNot(beNil())
                expect(value!.downloadMaxSecondsAfterPlay).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let value = AssetRights(json: AssetRightsJSON.missingKeys())
                
                expect(value).toNot(beNil())
                expect(value!.minBitrate).toNot(beNil())
                expect(value!.maxBitrate).to(beNil())
                expect(value!.maxResWidth).to(beNil())
                expect(value!.maxResHeight).to(beNil())
                expect(value!.playCount).to(beNil())
                expect(value!.maxFileSize).to(beNil())
                expect(value!.activation).to(beNil())
                expect(value!.expiration).to(beNil())
                expect(value!.maxAds).to(beNil())
                expect(value!.wifiBlocked).to(beNil())
                expect(value!.threeGBlocked).to(beNil())
                expect(value!.fourGBlocked).to(beNil())
                expect(value!.HDMIBlocked).to(beNil())
                expect(value!.airplayBlocked).to(beNil())
                expect(value!.downloadBlocked).to(beNil())
                expect(value!.streamingBlocked).to(beNil())
                expect(value!.analyticsEnabled).to(beNil())
                expect(value!.sessionShiftEnabled).to(beNil())
                expect(value!.rwEnabled).to(beNil())
                expect(value!.ffEnabled).to(beNil())
                expect(value!.amcDebugLogEnabled).to(beNil())
                expect(value!.locationEnabled).to(beNil())
                expect(value!.minPlayPosition).to(beNil())
                expect(value!.maxPlayPosition).to(beNil())
                expect(value!.jailbrokenBlocked).to(beNil())
                expect(value!.downloadMaxSecondsAfterDownload).to(beNil())
                expect(value!.downloadMaxSecondsAfterPlay).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let value = AssetRights(json: AssetRightsJSON.empty())
                
                //expect(value).to(beNil())
            }
        }
    }
}

extension AssetRightsSpec {
    enum AssetRightsJSON {
        static let minBitrate = 10
        static let maxBitrate = 10
        static let maxResWidth = 10
        static let maxResHeight = 10
        static let playCount = 10
        static let maxFileSize = 10
        static let activation = "activation"
        static let expiration = "expiration"
        static let maxAds = 1
        static let wifiBlocked = true
        static let threeGBlocked = true
        static let fourGBlocked = true
        static let HDMIBlocked = true
        static let airplayBlocked = false
        static let downloadBlocked = false
        static let streamingBlocked = false
        static let analyticsEnabled = false
        static let sessionShiftEnabled = false
        static let rwEnabled = false
        static let ffEnabled = true
        static let amcDebugLogEnabled = true
        static let locationEnabled = true
        static let minPlayPosition = 0
        static let maxPlayPosition = 10
        static let jailbrokenBlocked = true
        static let downloadMaxSecondsAfterDownload = 0
        static let downloadMaxSecondsAfterPlay = 10
        
        static func valid() -> Any {
            return [
                "minBitrate": AssetRightsJSON.minBitrate,
                "maxBitrate": AssetRightsJSON.maxBitrate,
                "maxResWidth": AssetRightsJSON.maxResWidth,
                "maxResHeight": AssetRightsJSON.maxResHeight,
                "playCount": AssetRightsJSON.playCount,
                "maxFileSize": AssetRightsJSON.maxFileSize,
                "activation": AssetRightsJSON.activation,
                "expiration": AssetRightsJSON.expiration,
                "maxAds": AssetRightsJSON.maxAds,
                "wifiBlocked": AssetRightsJSON.wifiBlocked,
                "threeGBlocked": AssetRightsJSON.threeGBlocked,
                "fourGBlocked": AssetRightsJSON.fourGBlocked,
                "HDMIBlocked": AssetRightsJSON.HDMIBlocked,
                "airplayBlocked": AssetRightsJSON.airplayBlocked,
                "downloadBlocked": AssetRightsJSON.downloadBlocked,
                "streamingBlocked": AssetRightsJSON.streamingBlocked,
                "analyticsEnabled": AssetRightsJSON.analyticsEnabled,
                "sessionShiftEnabled": AssetRightsJSON.sessionShiftEnabled,
                "rwEnabled": AssetRightsJSON.rwEnabled,
                "ffEnabled": AssetRightsJSON.ffEnabled,
                "amcDebugLogEnabled": AssetRightsJSON.amcDebugLogEnabled,
                "locationEnabled": AssetRightsJSON.locationEnabled,
                "minPlayPosition": AssetRightsJSON.minPlayPosition,
                "maxPlayPosition": AssetRightsJSON.maxPlayPosition,
                "jailbrokenBlocked": AssetRightsJSON.jailbrokenBlocked,
                "downloadMaxSecondsAfterDownload": AssetRightsJSON.downloadMaxSecondsAfterDownload,
                "downloadMaxSecondsAfterPlay": AssetRightsJSON.downloadMaxSecondsAfterPlay,
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "minBitrate": AssetRightsJSON.minBitrate
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
