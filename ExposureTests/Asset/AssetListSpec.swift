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
                let json = AssetListJSON.valid()
                let result = json.decode(AssetList.self)
                
                expect(result).toNot(beNil())
                expect(result?.totalCount).toNot(beNil())
                expect(result?.pageSize).toNot(beNil())
                expect(result?.pageNumber).toNot(beNil())
                expect(result?.items).toNot(beNil())
            }
            
            it("should init with partial response") {
                let json = AssetListJSON.missingKeys()
                let result = json.decode(AssetList.self)
                
                expect(result).toNot(beNil())
                expect(result?.totalCount).toNot(beNil())
                expect(result?.pageSize).to(beNil())
                expect(result?.pageNumber).to(beNil())
                expect(result?.items).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let json = AssetListJSON.empty()
                let result = json.decode(AssetList.self)
                
                expect(result).to(beNil())
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
        static func valid() -> [String: Any] {
            return [
                "totalCount": AssetListJSON.totalCount,
                "pageSize": AssetListJSON.pageSize,
                "pageNumber": AssetListJSON.pageNumber,
                "items": AssetListJSON.items
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "totalCount": AssetListJSON.totalCount
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
