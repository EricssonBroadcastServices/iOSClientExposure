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
                let json = ProgramJSON.valid()
                
                let result = try? json.decode(Program.self)
                
                expect(result).toNot(beNil())
                expect(result?.created).toNot(beNil())
                expect(result?.changed).toNot(beNil())
                expect(result?.programId).toNot(beNil())
                expect(result?.assetId).toNot(beNil())
                expect(result?.channelId).toNot(beNil())
                expect(result?.startTime).toNot(beNil())
                expect(result?.endTime).toNot(beNil())
                expect(result?.vodAvailable).toNot(beNil())
                expect(result?.catchup).toNot(beNil())
                expect(result?.catchupBlocked).toNot(beNil())
                expect(result?.asset).toNot(beNil())
                expect(result?.blackout).toNot(beNil())
            }
            
            it("should init with partial response") {
                let json = ProgramJSON.missingKeys()
                
                let result = try? json.decode(Program.self)
                
                expect(result).toNot(beNil())
                expect(result?.created).toNot(beNil())
                expect(result?.changed).to(beNil())
                expect(result?.programId).to(beNil())
                expect(result?.assetId).to(beNil())
                expect(result?.channelId).to(beNil())
                expect(result?.startTime).to(beNil())
                expect(result?.endTime).to(beNil())
                expect(result?.vodAvailable).to(beNil())
                expect(result?.catchup).to(beNil())
                expect(result?.catchupBlocked).to(beNil())
                expect(result?.asset).to(beNil())
                expect(result?.blackout).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let json = ProgramJSON.empty()
                
                expect(result).to(beNil())
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
        
        static func valid() -> [String: Any] {
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
        
        static func missingKeys() -> [String: Any] {
            return [
                "created": ProgramJSON.created
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
