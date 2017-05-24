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

@testable import Exposure

class TagsSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let tags = Tag(json: TagsJSON.valid())
                
                expect(tags).toNot(beNil())
                expect(tags!.created).toNot(beNil())
                expect(tags!.changed).toNot(beNil())
                expect(tags!.type).toNot(beNil())
                expect(tags!.tagValues).toNot(beNil())
                
                let tagValue = tags!.tagValues!.first
                expect(tagValue).toNot(beNil())
                expect(tagValue?.tagId).toNot(beNil())
            }
            
            it("should init with partial response") {
                let tags = Tag(json: TagsJSON.missingKeys())
                
                expect(tags).toNot(beNil())
                expect(tags!.created).toNot(beNil())
                expect(tags!.changed).to(beNil())
                expect(tags!.type).to(beNil())
                expect(tags!.tagValues).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let tags = Tag(json: TagsJSON.empty())
                
                expect(tags).to(beNil())
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
        static func valid() -> Any {
            return [
                "created": TagsJSON.created,
                "changed": TagsJSON.changed,
                "type": TagsJSON.type,
                "tagValues": TagsJSON.tagValues
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "created": TagsJSON.created
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
