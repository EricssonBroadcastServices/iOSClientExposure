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
                let object = ChannelEpg(json: ChannelEpgJSON.valid())
                
                expect(object).toNot(beNil())
                expect(object!.channelId).toNot(beNil())
                expect(object!.programs).toNot(beNil())
                expect(object!.totalHitsAllChannels).toNot(beNil())
            }
            
            it("should init with partial response") {
                let object = ChannelEpg(json: ChannelEpgJSON.missingKeys())
                
                expect(object).toNot(beNil())
                expect(object!.channelId).toNot(beNil())
                expect(object!.programs).to(beNil())
                expect(object!.totalHitsAllChannels).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let object = ChannelEpg(json: ChannelEpgJSON.empty())
                
                expect(object).to(beNil())
            }
        }
    }
}

extension ChannelEpgSpec {
    enum ChannelEpgJSON {
        static let channelId = "channelId"
        static let programs = [ProgramSpec.ProgramJSON.valid()]
        static let totalHitsAllChannels = 10
        
        static func valid() -> Any {
            return [
                "channelId": ChannelEpgJSON.channelId,
                "programs": ChannelEpgJSON.programs,
                "totalHitsAllChannels": ChannelEpgJSON.totalHitsAllChannels,
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "channelId": ChannelEpgJSON.channelId
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
