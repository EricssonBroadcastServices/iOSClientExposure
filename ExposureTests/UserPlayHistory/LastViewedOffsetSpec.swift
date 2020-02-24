//
//  LastViewedOffsetSpec.swift
//  Exposure
//
//  Created by Johnny Sundblom on 2020-02-20.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import Exposure

class LastViewedOffsetSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = LastViewedOffsetJSON.valid()
                let result = json.decode(LastViewedOffset.self)
                
                expect(result).toNot(beNil())
                expect(result?.assetId).toNot(beNil())
                expect(result?.channelId).toNot(beNil())
                expect(result?.lastViewedOffset).toNot(beNil())
                expect(result?.lastViewedTime).toNot(beNil())
                expect(result?.liveTime).toNot(beNil())
                expect(result?.programId).toNot(beNil())
            }

            it("should succeed with missing keys") {
                let json = LastViewedOffsetJSON.missingKeys()
                let result = json.decode(LastViewedOffset.self)
                
                expect(result).toNot(beNil())
                expect(result?.assetId).to(beNil())
                expect(result?.channelId).to(beNil())
                expect(result?.lastViewedOffset).to(beNil())
                expect(result?.lastViewedTime).toNot(beNil())
                expect(result?.liveTime).toNot(beNil())
                expect(result?.programId).toNot(beNil())
            }
            
            it("should init with empty or non matching response") {
                let json = LastViewedOffsetJSON.empty()
                let result = json.decode(LastViewedOffset.self)
                
                expect(result).toNot(beNil())
            }
        }
    }
}

extension LastViewedOffsetSpec {
    enum LastViewedOffsetJSON {
        static let assetId = "assetId"
        static let channelId = "channelId"
        static let programId = "programId"
        static let lastViewedOffset = 100
        static let lastViewedTime = 200
        static let liveTime = 200
        
        static func valid() -> [String: Any] {
            return [
                "assetId": assetId,
                "channelId": channelId,
                "lastViewedOffset": lastViewedOffset,
                "lastViewedTime": lastViewedTime,
                "liveTime": liveTime,
                "programId": programId
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "lastViewedTime": lastViewedTime,
                "liveTime": liveTime,
                "programId": programId
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
