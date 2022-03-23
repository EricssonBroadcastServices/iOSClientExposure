//
//  SearchResponseAutocompleteSpec.swift
//  ExposureTests
//
//  Created by Fredrik Sjöberg on 2017-10-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import iOSClientExposure

class SearchResponseAutocompleteSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = SearchResponseAutocompleteJSON.valid()
                let result = json.decode(SearchResponseAutocomplete.self)
                
                expect(result).toNot(beNil())
                expect(result?.text).toNot(beNil())
                expect(result?.assetId).toNot(beNil())
            }
            
            it("should not init with partial response") {
                let json = SearchResponseAutocompleteJSON.missingKeys()
                let result = json.decode(SearchResponseAutocomplete.self)
                
                expect(result).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let json = SearchResponseAutocompleteJSON.empty()
                let result = json.decode(SearchResponseAutocomplete.self)
                
                expect(result).to(beNil())
            }
        }
    }
}

extension SearchResponseAutocompleteSpec {
    enum SearchResponseAutocompleteJSON {
        static let text = "text"
        static let assetId = "assetId"
        
        static func valid() -> [String: Any] {
            return [
                "text": SearchResponseAutocompleteJSON.text,
                "assetId": SearchResponseAutocompleteJSON.assetId,
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "text": SearchResponseAutocompleteJSON.text
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
