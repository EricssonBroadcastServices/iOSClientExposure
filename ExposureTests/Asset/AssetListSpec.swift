//
//  AssetListSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-24.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class AssetListSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let value = AssetList(json: AssetListJSON.valid())
                
                expect(value).toNot(beNil())
                expect(value!.totalCount).toNot(beNil())
                expect(value!.pageSize).toNot(beNil())
                expect(value!.pageNumber).toNot(beNil())
                expect(value!.items).toNot(beNil())
            }
            
            it("should init with partial response") {
                let value = AssetList(json: AssetListJSON.missingKeys())
                
                expect(value).toNot(beNil())
                expect(value!.totalCount).toNot(beNil())
                expect(value!.pageSize).to(beNil())
                expect(value!.pageNumber).to(beNil())
                expect(value!.items).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let value = AssetList(json: AssetListJSON.empty())
                
                expect(value).to(beNil())
            }
        }
    }
}

extension AssetListSpec {
    enum AssetListJSON {
        static let totalCount = 10
        static let pageSize = 1
        static let pageNumber = 1
        static let items = [AssetSpec.AssetJSON.valid()]
        static func valid() -> Any {
            return [
                "totalCount": AssetListJSON.totalCount,
                "pageSize": AssetListJSON.pageSize,
                "pageNumber": AssetListJSON.pageNumber,
                "items": AssetListJSON.items
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "totalCount": AssetListJSON.totalCount
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
