//
//  AssetUserDataSpec.swift
//  ExposureTests
//
//  Created by Fredrik Sjöberg on 2017-09-29.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class AssetUserDataSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = AssetUserDataJSON.valid()
                let result = json.decode(AssetUserData.self)
                
                expect(result).toNot(beNil())
                expect(result?.playHistory).toNot(beNil())
            }
            
            it("should init with empty or non matching response") {
                let result = AssetUserDataJSON.incomplete().decode(AssetUserData.self)
                
                expect(result).to(beNil())
            }
            
            it("should init with empty or non matching response") {
                let json = AssetUserDataJSON.empty()
                let result = json.decode(AssetUserData.self)
                
                expect(result).to(beNil())
            }
        }
    }
}

extension AssetUserDataSpec {
    enum AssetUserDataJSON {
        static func valid() -> [String: Codable] {
            return [
                "playHistory": AssetUserPlayHistorySpec.AssetUserPlayHistoryJSON.valid()
            ]
        }
        
        static func incomplete() -> [String: Codable] {
            return [
                "playHistory": ""
            ]
        }
        
        static func empty() -> [String: Codable] {
            return [:]
        }
    }
}
