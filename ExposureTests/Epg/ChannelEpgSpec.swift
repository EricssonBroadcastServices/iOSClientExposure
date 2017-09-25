//
//  ChannelEpgSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class ChannelEpgSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = ChannelEpgJSON.valid()
                
                let result = json.decode(ChannelEpg.self)
                
                expect(result).toNot(beNil())
                expect(result?.channelId).toNot(beNil())
                expect(result?.programs).toNot(beNil())
                expect(result?.totalHitsAllChannels).toNot(beNil())
            }
            
            it("should init with partial response") {
                let json = ChannelEpgJSON.missingKeys()
                
                let result = json.decode(ChannelEpg.self)
                
                expect(result).toNot(beNil())
                expect(result?.channelId).toNot(beNil())
                expect(result?.programs).to(beNil())
                expect(result?.totalHitsAllChannels).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let json = ChannelEpgJSON.empty()
                
                let result = json.decode(ChannelEpg.self)
                expect(result).to(beNil())
            }
        }
    }
}

extension ChannelEpgSpec {
    enum ChannelEpgJSON {
        static let channelId = "channelId"
        static let programs = [ProgramSpec.ProgramJSON.valid()]
        static let totalHitsAllChannels = 10
        
        static func valid() -> [String: Any] {
            return [
                "channelId": ChannelEpgJSON.channelId,
                "programs": ChannelEpgJSON.programs,
                "totalHitsAllChannels": ChannelEpgJSON.totalHitsAllChannels,
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "channelId": ChannelEpgJSON.channelId
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
