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
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = LocalizedDataJSON.valid()
                let result = json.decode(LocalizedData.self)
                
                expect(result).toNot(beNil())
                expect(result?.locale).toNot(beNil())
                expect(result?.title).toNot(beNil())
                expect(result?.sortingTitle).toNot(beNil())
                expect(result?.description).toNot(beNil())
                expect(result?.tinyDescription).toNot(beNil())
                expect(result?.shortDescription).toNot(beNil())
                expect(result?.longDescription).toNot(beNil())
                expect(result?.images).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let json = LocalizedDataJSON.missingKeys()
                let result = json.decode(LocalizedData.self)
                
                expect(result).toNot(beNil())
                expect(result?.locale).toNot(beNil())
                expect(result?.title).to(beNil())
                expect(result?.sortingTitle).to(beNil())
                expect(result?.description).to(beNil())
                expect(result?.tinyDescription).to(beNil())
                expect(result?.shortDescription).to(beNil())
                expect(result?.longDescription).to(beNil())
                expect(result?.images).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let json = LocalizedDataJSON.empty()
                let result = json.decode(LocalizedData.self)
                
                expect(result).to(beNil())
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
        static func valid() -> [String: Codable] {
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
        
        static func missingKeys() -> [String: Codable] {
            return [
                "locale": LocalizedDataJSON.locale
            ]
        }
        
        static func empty() -> [String: Codable] {
            return [:]
        }
    }
}
