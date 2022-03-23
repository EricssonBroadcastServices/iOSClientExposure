//
//  AssetUserPlayHistorySpec.swift
//  ExposureTests
//
//  Created by Fredrik Sjöberg on 2017-09-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import iOSClientExposure

class AssetUserPlayHistorySpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = AssetUserPlayHistoryJSON.valid()
                let result = json.decode(AssetUserPlayHistory.self)
                
                expect(result).toNot(beNil())
                expect(result?.lastViewedOffset).toNot(beNil())
                expect(result?.lastViewedTime).toNot(beNil())
                expect(result?.programId).toNot(beNil())
                expect(result?.channelId).toNot(beNil())
            }
            
            it("should succeed with only required keys") {
                let json = AssetUserPlayHistoryJSON.requiredKeys()
                let result = json.decode(AssetUserPlayHistory.self)
                
                expect(result).toNot(beNil())
                expect(result?.lastViewedOffset).toNot(beNil())
                expect(result?.lastViewedTime).toNot(beNil())
                expect(result?.programId).to(beNil())
                expect(result?.channelId).to(beNil())
            }
            
            it("should fail when missing required keys") {
                let json = AssetUserPlayHistoryJSON.missingKeys()
                let result = json.decode(AssetUserPlayHistory.self)
                
                expect(result).to(beNil())
            }
        }
    }
}

extension AssetUserPlayHistorySpec {
    enum AssetUserPlayHistoryJSON {
        static let lastViewedOffset = 100
        static let lastViewedTime = 200
        static let programId = "programId"
        static let channelId = "channelId"
        
        static func valid() -> [String: Any] {
            return [
                "lastViewedOffset": AssetUserPlayHistoryJSON.lastViewedOffset,
                "lastViewedTime": AssetUserPlayHistoryJSON.lastViewedTime,
                "programId": AssetUserPlayHistoryJSON.programId,
                "channelId": AssetUserPlayHistoryJSON.channelId
            ]
        }
        
        static func requiredKeys() -> [String: Any] {
            return [
                "lastViewedOffset": AssetUserPlayHistoryJSON.lastViewedOffset,
                "lastViewedTime": AssetUserPlayHistoryJSON.lastViewedTime
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "lastViewedTime": AssetUserPlayHistoryJSON.lastViewedTime,
                "programId": AssetUserPlayHistoryJSON.programId,
                "channelId": AssetUserPlayHistoryJSON.channelId
            ]
        }
    }
}
