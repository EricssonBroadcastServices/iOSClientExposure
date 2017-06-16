//
//  ProgramSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class ProgramSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let object = Program(json: ProgramJSON.valid())
                
                expect(object).toNot(beNil())
                expect(object!.created).toNot(beNil())
                expect(object!.changed).toNot(beNil())
                expect(object!.programId).toNot(beNil())
                expect(object!.assetId).toNot(beNil())
                expect(object!.channelId).toNot(beNil())
                expect(object!.startTime).toNot(beNil())
                expect(object!.endTime).toNot(beNil())
                expect(object!.vodAvailable).toNot(beNil())
                expect(object!.catchup).toNot(beNil())
                expect(object!.catchupBlocked).toNot(beNil())
                expect(object!.asset).toNot(beNil())
                expect(object!.blackout).toNot(beNil())
            }
            
            it("should init with partial response") {
                let object = Program(json: ProgramJSON.missingKeys())
                
                expect(object).toNot(beNil())
                expect(object!.created).toNot(beNil())
                expect(object!.changed).to(beNil())
                expect(object!.programId).to(beNil())
                expect(object!.assetId).to(beNil())
                expect(object!.channelId).to(beNil())
                expect(object!.startTime).to(beNil())
                expect(object!.endTime).to(beNil())
                expect(object!.vodAvailable).to(beNil())
                expect(object!.catchup).to(beNil())
                expect(object!.catchupBlocked).to(beNil())
                expect(object!.asset).to(beNil())
                expect(object!.blackout).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let object = Program(json: ProgramJSON.empty())
                
                expect(object).to(beNil())
            }
        }
    }
}

extension ProgramSpec {
    enum ProgramJSON {
        static let created = "created"
        static let changed = "changed"
        static let programId = "programId"
        static let assetId = "assetId"
        static let channelId = "channelId"
        static let startTime = "startTime"
        static let endTime = "endTime"
        static let vodAvailable = false
        static let catchup = false
        static let catchupBlocked = false
        static let asset = AssetSpec.AssetJSON.valid()
        static let blackout = false
        
        static func valid() -> Any {
            return [
                "created": ProgramJSON.created,
                "changed": ProgramJSON.changed,
                "programId": ProgramJSON.programId,
                "assetId": ProgramJSON.assetId,
                "channelId": ProgramJSON.channelId,
                "startTime": ProgramJSON.startTime,
                "endTime": ProgramJSON.endTime,
                "vodAvailable": ProgramJSON.vodAvailable,
                "catchup": ProgramJSON.catchup,
                "catchupBlocked": ProgramJSON.catchupBlocked,
                "asset": ProgramJSON.asset,
                "blackout": ProgramJSON.blackout
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "created": ProgramJSON.created
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
