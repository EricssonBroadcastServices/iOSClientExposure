//
//  ContinueTVShowSpec.swift
//  Exposure
//
//  Created by Johnny Sundblom on 2020-03-02.
//  Copyright © 2020 emp. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import iOSClientExposure

class ContinueTVShowSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = ContinueTVShowSpecJSON.valid()
                let result = json.decode(ContinueTVShow.self)
                
                expect(result).toNot(beNil())
                expect(result?.asset).toNot(beNil())
                expect(result?.startedWatching).toNot(beNil())
                expect(result?.lastViewedOffset).toNot(beNil())
            }

            it("should not succded with missing keys") {
                let json = ContinueTVShowSpecJSON.missingKeys()
                let result = json.decode(ContinueTVShow.self)
                
                expect(result).to(beNil())
            }
            
            it("should not succeed empty or non matching response") {
                let json = ContinueTVShowSpecJSON.empty()
                let result = json.decode(ContinueTVShow.self)
                
                expect(result).to(beNil())
            }
        }
    }
}

extension ContinueTVShowSpec {
    enum ContinueTVShowSpecJSON {
        static let startedWatching = false
        static let lastViewedOffset = 100
        
        static func valid() -> [String: Any] {
            return [
                "asset": AssetSpec.AssetJSON.valid(),
                "startedWatching": true,
                "lastViewedOffset": 100            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "lastViewedTime": 100
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
