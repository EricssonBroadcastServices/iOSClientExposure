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
                let json = AssetRightsJSON.valid()
                let result = json.decode(AssetRights.self)
                
                expect(result).toNot(beNil())
                expect(result?.minBitrate).toNot(beNil())
                expect(result?.maxBitrate).toNot(beNil())
                expect(result?.maxResWidth).toNot(beNil())
                expect(result?.maxResHeight).toNot(beNil())
                expect(result?.playCount).toNot(beNil())
                expect(result?.maxFileSize).toNot(beNil())
                expect(result?.activation).toNot(beNil())
                expect(result?.expiration).toNot(beNil())
                expect(result?.maxAds).toNot(beNil())
                expect(result?.wifiBlocked).toNot(beNil())
                expect(result?.threeGBlocked).toNot(beNil())
                expect(result?.fourGBlocked).toNot(beNil())
                expect(result?.HDMIBlocked).toNot(beNil())
                expect(result?.airplayBlocked).toNot(beNil())
                expect(result?.downloadBlocked).toNot(beNil())
                expect(result?.streamingBlocked).toNot(beNil())
                expect(result?.analyticsEnabled).toNot(beNil())
                expect(result?.sessionShiftEnabled).toNot(beNil())
                expect(result?.rwEnabled).toNot(beNil())
                expect(result?.ffEnabled).toNot(beNil())
                expect(result?.amcDebugLogEnabled).toNot(beNil())
                expect(result?.locationEnabled).toNot(beNil())
                expect(result?.minPlayPosition).toNot(beNil())
                expect(result?.maxPlayPosition).toNot(beNil())
                expect(result?.jailbrokenBlocked).toNot(beNil())
                expect(result?.downloadMaxSecondsAfterDownload).toNot(beNil())
                expect(result?.downloadMaxSecondsAfterPlay).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let json = AssetRightsJSON.missingKeys()
                let result = json.decode(AssetRights.self)
                
                expect(result).toNot(beNil())
                expect(result?.minBitrate).toNot(beNil())
                expect(result?.maxBitrate).to(beNil())
                expect(result?.maxResWidth).to(beNil())
                expect(result?.maxResHeight).to(beNil())
                expect(result?.playCount).to(beNil())
                expect(result?.maxFileSize).to(beNil())
                expect(result?.activation).to(beNil())
                expect(result?.expiration).to(beNil())
                expect(result?.maxAds).to(beNil())
                expect(result?.wifiBlocked).to(beNil())
                expect(result?.threeGBlocked).to(beNil())
                expect(result?.fourGBlocked).to(beNil())
                expect(result?.HDMIBlocked).to(beNil())
                expect(result?.airplayBlocked).to(beNil())
                expect(result?.downloadBlocked).to(beNil())
                expect(result?.streamingBlocked).to(beNil())
                expect(result?.analyticsEnabled).to(beNil())
                expect(result?.sessionShiftEnabled).to(beNil())
                expect(result?.rwEnabled).to(beNil())
                expect(result?.ffEnabled).to(beNil())
                expect(result?.amcDebugLogEnabled).to(beNil())
                expect(result?.locationEnabled).to(beNil())
                expect(result?.minPlayPosition).to(beNil())
                expect(result?.maxPlayPosition).to(beNil())
                expect(result?.jailbrokenBlocked).to(beNil())
                expect(result?.downloadMaxSecondsAfterDownload).to(beNil())
                expect(result?.downloadMaxSecondsAfterPlay).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let json = AssetRightsJSON.empty()
                let result = json.decode(AssetRights.self)
                
                expect(result).to(beNil())
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
        
        static func valid() -> [String: Any] {
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
        
        static func missingKeys() -> [String: Any] {
            return [
                "minBitrate": AssetRightsJSON.minBitrate
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
