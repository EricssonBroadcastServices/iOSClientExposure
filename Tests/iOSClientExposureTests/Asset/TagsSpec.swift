//
//  TagsSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-16.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import iOSClientExposure

class TagsSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = TagsJSON.valid()
                let result = json.decode(Tag.self)
                
                expect(result).toNot(beNil())
                expect(result?.created).toNot(beNil())
                expect(result?.changed).toNot(beNil())
                expect(result?.type).toNot(beNil())
                expect(result?.tagValues).toNot(beNil())
                
                let tagValue = result?.tagValues?.first
                expect(tagValue).toNot(beNil())
                expect(tagValue?.tagId).toNot(beNil())
            }
            
            it("should init with partial response") {
                let json = TagsJSON.missingKeys()
                let result = json.decode(Tag.self)
                
                expect(result).toNot(beNil())
                expect(result?.created).toNot(beNil())
                expect(result?.changed).to(beNil())
                expect(result?.type).to(beNil())
                expect(result?.tagValues).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let json = TagsJSON.empty()
                let result = json.decode(Tag.self)
                
                expect(result).toNot(beNil())
            }
        }
    }
}

extension TagsSpec {
    enum TagsJSON {
        static let created = "2016-10-28T11:52:41Z"
        static let changed = "2016-10-28T12:01:20Z"
        static let type = "genre"
        static let tagValues = [["tagId": "tg002_qwerty"]]
        static func valid() -> [String: Any] {
            return [
                "created": TagsJSON.created,
                "changed": TagsJSON.changed,
                "type": TagsJSON.type,
                "tagValues": TagsJSON.tagValues
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "created": TagsJSON.created
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
