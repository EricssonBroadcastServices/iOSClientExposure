//
//  AssetFeatureImage.swift
//  Exposure
//
//  Created by Alessandro dos Santos Pinto on 2023-05-16.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import iOSClientExposure

class AssetFeatureImageSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = AssetFeatureImageJSON.valid()
                let result = json.decode(AssetFeatureImage.self)
                
                expect(result).toNot(beNil())
                expect(result?.url).toNot(beNil())
                expect(result?.selectors).toNot(beNil())
                
            }
            
            it("should init with partial response") {
                let json = AssetFeatureImageJSON.missingKeys()
                let result = json.decode(AssetFeatureImage.self)

                expect(result).toNot(beNil())
                expect(result?.url).to(beNil())
                expect(result?.selectors).toNot(beNil())
            }
            
            it("should init with empty response") {
                let json = AssetFeatureImageJSON.empty()
                let result = json.decode(AssetFeatureImage.self)
                
                expect(result).toNot(beNil())
            }
        }
    }
}

extension AssetFeatureImageSpec {
    enum AssetFeatureImageJSON {
        static let url = "https://ps.vemup.ctl.cdn.ebsd.ericsson.net/public/globalassets/mprop/DLB_Atms_vert_rgb_wht_@2x.png"
        static let selectors = ["light", "vertical"]
        static func valid() -> [String: Any] {
            return [
                "url": AssetFeatureImageJSON.url,
                "selectors": AssetFeatureImageJSON.selectors
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "selectors": AssetFeatureImageJSON.selectors
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
