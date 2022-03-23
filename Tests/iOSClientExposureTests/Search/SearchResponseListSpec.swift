//
//  SearchResponseListListSpec.swift
//  ExposureTests
//
//  Created by Fredrik Sjöberg on 2017-10-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import iOSClientExposure

class SearchResponseListSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = SearchResponseListJSON.valid()
                let result = json.decode(SearchResponseList.self)
                
                expect(result).toNot(beNil())
                expect(result?.items).toNot(beNil())
                expect(result?.totalCount).toNot(beNil())
                expect(result?.pageSize).toNot(beNil())
                expect(result?.pageNumber).toNot(beNil())
                expect(result?.suggestion).toNot(beNil())
            }
            
            it("should init with partial response") {
                let json = SearchResponseListJSON.missingKeys()
                let result = json.decode(SearchResponseList.self)
                
                expect(result).toNot(beNil())
                expect(result?.items).toNot(beNil())
                expect(result?.totalCount).toNot(beNil())
                expect(result?.pageSize).toNot(beNil())
                expect(result?.pageNumber).toNot(beNil())
                expect(result?.suggestion).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let json = SearchResponseListJSON.empty()
                let result = json.decode(SearchResponseList.self)
                
                expect(result).to(beNil())
            }
        }
    }
}

extension SearchResponseListSpec {
    enum SearchResponseListJSON {
        static let items = [SearchResponseSpec.SearchResponseJSON.valid()]
        static let totalCount = 100
        static let pageSize = 2
        static let pageNumber = 50
        static let suggestion = "suggestion"
        
        static func valid() -> [String: Any] {
            return [
                "items": SearchResponseListJSON.items,
                "totalCount": SearchResponseListJSON.totalCount,
                "pageSize": SearchResponseListJSON.pageSize,
                "pageNumber": SearchResponseListJSON.pageNumber,
                "suggestion": SearchResponseListJSON.suggestion
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "items": SearchResponseListJSON.items,
                "totalCount": SearchResponseListJSON.totalCount,
                "pageSize": SearchResponseListJSON.pageSize,
                "pageNumber": SearchResponseListJSON.pageNumber
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
