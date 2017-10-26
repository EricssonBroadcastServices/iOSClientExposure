//
//  SearchResponseSpec.swift
//  ExposureTests
//
//  Created by Fredrik Sjöberg on 2017-10-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class SearchResponseSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = SearchResponseJSON.valid()
                let result = json.decode(SearchResponse.self)
                
                expect(result).toNot(beNil())
                expect(result?.asset).toNot(beNil())
                expect(result?.highlightedTitle).toNot(beNil())
                expect(result?.highlightedDescription).toNot(beNil())
            }
            
            it("should init with partial response") {
                let json = SearchResponseJSON.missingKeys()
                let result = json.decode(SearchResponse.self)
                
                expect(result).toNot(beNil())
                expect(result?.asset).toNot(beNil())
                expect(result?.highlightedTitle).to(beNil())
                expect(result?.highlightedDescription).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let json = SearchResponseJSON.empty()
                let result = json.decode(SearchResponse.self)
                
                expect(result).to(beNil())
            }
        }
    }
}

extension SearchResponseSpec {
    enum SearchResponseJSON {
        static let asset = AssetSpec.AssetJSON.valid()
        static let highlightedTitle = "highlightedTitle"
        static let highlightedDescription = "highlightedDescription"
        
        static func valid() -> [String: Codable] {
            return [
                "asset": SearchResponseJSON.asset,
                "highlightedTitle": SearchResponseJSON.highlightedTitle,
                "highlightedDescription": SearchResponseJSON.highlightedDescription
            ]
        }
        
        static func missingKeys() -> [String: Codable] {
            return [
                "asset": SearchResponseJSON.asset
            ]
        }
        
        static func empty() -> [String: Codable] {
            return [:]
        }
    }
}
