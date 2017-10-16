//
//  SearchResponseSpellingSpec.swift
//  ExposureTests
//
//  Created by Fredrik Sjöberg on 2017-10-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class SearchResponseSpellingSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = SearchResponseSpellingJSON.valid()
                let result = json.decode(SearchResponseSpelling.self)
                
                expect(result).toNot(beNil())
                expect(result?.text).toNot(beNil())
                expect(result?.assetId).toNot(beNil())
            }
            
            it("should init with partial response") {
                let json = SearchResponseSpellingJSON.missingKeys()
                let result = json.decode(SearchResponseSpelling.self)
                
                expect(result).toNot(beNil())
                expect(result?.text).toNot(beNil())
                expect(result?.assetId).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let json = SearchResponseSpellingJSON.empty()
                let result = json.decode(SearchResponseSpelling.self)
                
                expect(result).to(beNil())
            }
        }
    }
}

extension SearchResponseSpellingSpec {
    enum SearchResponseSpellingJSON {
        static let text = "text"
        static let assetId = "assetId"
        
        static func valid() -> [String: Codable] {
            return [
                "text": SearchResponseSpellingJSON.text,
                "assetId": SearchResponseSpellingJSON.assetId,
            ]
        }
        
        static func missingKeys() -> [String: Codable] {
            return [
                "text": SearchResponseSpellingJSON.text
            ]
        }
        
        static func empty() -> [String: Codable] {
            return [:]
        }
    }
}
