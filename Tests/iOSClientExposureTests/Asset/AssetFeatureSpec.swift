//
//  AssetFeatureSpec.swift
//  Exposure
//
//  Created by Alessandro dos Santos Pinto on 2023-05-16.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import iOSClientExposure

class AssetFeatureSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = AssetFeatureJSON.valid()
                let result = json.decode(AssetFeature.self)
                
                expect(result).toNot(beNil())
                expect(result?.id).toNot(beNil())
                expect(result?.images).toNot(beNil())
                
            }
            
            it("should init with partial response") {
                let json = AssetFeatureJSON.missingKeys()
                let result = json.decode(AssetFeature.self)

                expect(result).toNot(beNil())
                expect(result?.id).to(beNil())
                expect(result?.images).toNot(beNil())
            }
            
            it("should init with empty response") {
                let json = AssetFeatureJSON.empty()
                let result = json.decode(AssetFeature.self)
                
                expect(result).toNot(beNil())
            }
        }
    }
}

extension AssetFeatureSpec {
    enum AssetFeatureJSON {
        static let id = "dolby-atmos"
        static let images = [AssetFeatureImageSpec.AssetFeatureImageJSON.valid()]
        static func valid() -> [String: Any] {
            return [
                "id": AssetFeatureJSON.id,
                "images": AssetFeatureJSON.images
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "images": AssetFeatureJSON.images
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}

