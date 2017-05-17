//
//  LocalizedDataSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-17.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class LocalizedDataSpec: QuickSpec {
    
    typealias LocalizedData = Asset.LocalizedData
    
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let value = LocalizedData(json: LocalizedDataJSON.valid())
                
                expect(value).toNot(beNil())
                expect(value!.locale).toNot(beNil())
                expect(value!.title).toNot(beNil())
                expect(value!.sortingTitle).toNot(beNil())
                expect(value!.description).toNot(beNil())
                expect(value!.tinyDescription).toNot(beNil())
                expect(value!.shortDescription).toNot(beNil())
                expect(value!.longDescription).toNot(beNil())
                expect(value!.images).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let value = LocalizedData(json: LocalizedDataJSON.missingKeys())
                
                expect(value).toNot(beNil())
                expect(value!.locale).toNot(beNil())
                expect(value!.title).to(beNil())
                expect(value!.sortingTitle).to(beNil())
                expect(value!.description).to(beNil())
                expect(value!.tinyDescription).to(beNil())
                expect(value!.shortDescription).to(beNil())
                expect(value!.longDescription).to(beNil())
                expect(value!.images).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let value = LocalizedData(json: LocalizedDataJSON.empty())
                
                expect(value).to(beNil())
            }
        }
    }
}

extension LocalizedDataSpec {
    enum LocalizedDataJSON {
        static let locale = "en"
        static let title = "Max & Ruby"
        static let sortingTitle = "Max & Ruby"
        static let description = "description"
        static let tinyDescription = "tinyDescription"
        static let shortDescription = "shortDescription"
        static let longDescription = "longDescription"
        static let images = [ImageSpec.ImageJSON.valid()]
        static func valid() -> Any {
            return [
                "locale": LocalizedDataJSON.locale,
                "title": LocalizedDataJSON.title,
                "sortingTitle": LocalizedDataJSON.sortingTitle,
                "description": LocalizedDataJSON.description,
                "tinyDescription": LocalizedDataJSON.tinyDescription,
                "shortDescription": LocalizedDataJSON.shortDescription,
                "longDescription": LocalizedDataJSON.longDescription,
                "images": LocalizedDataJSON.images
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "locale": LocalizedDataJSON.locale
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
