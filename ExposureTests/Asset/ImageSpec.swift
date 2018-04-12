//
//  ImageSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-16.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class ImageSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = ImageJSON.valid()
                let result = json.decode(Image.self)
                
                expect(result).toNot(beNil())
                expect(result?.height).toNot(beNil())
                expect(result?.orientation).toNot(beNil())
                expect(result?.type).toNot(beNil())
                expect(result?.url).toNot(beNil())
                expect(result?.width).toNot(beNil())
            }
            
            it("should init with partial response") {
                let json = ImageJSON.missingKeys()
                let result = json.decode(Image.self)
                
                expect(result).toNot(beNil())
                expect(result?.height).to(beNil())
                expect(result?.orientation).to(beNil())
                expect(result?.type).to(beNil())
                expect(result?.url).to(beNil())
                expect(result?.width).toNot(beNil())
            }
            
            it("should init with empty response") {
                let json = ImageJSON.empty()
                let result = json.decode(Image.self)
                
                expect(result).toNot(beNil())
            }
        }
    }
}

extension ImageSpec {
    enum ImageJSON {
        static let url = "https://azukifilesprestage.blob.core.windows.net/img/VU-21702_qwerty-b4fead6f454a4fe2ba1d6b391fb9f5ab_other.jpg"
        static let height = 700
        static let width = 500
        static let orientation = "PORTRAIT"
        static let type = "other"
        static func valid() -> [String: Any] {
            return [
                "url": ImageJSON.url,
                "height": ImageJSON.height,
                "width": ImageJSON.width,
                "orientation": ImageJSON.orientation,
                "type": ImageJSON.type
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "width": ImageJSON.width
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
