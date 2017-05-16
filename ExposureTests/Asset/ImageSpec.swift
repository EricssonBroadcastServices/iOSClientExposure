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
    
    typealias Image = Asset.Image
    
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let image = Image(json: ImageJSON.valid())
                
                expect(image).toNot(beNil())
                expect(image!.height).toNot(beNil())
                expect(image!.orientation).toNot(beNil())
                expect(image!.type).toNot(beNil())
                expect(image!.url).toNot(beNil())
                expect(image!.width).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let image = Image(json: ImageJSON.missingKeys())
                
                expect(image).toNot(beNil())
                expect(image!.height).to(beNil())
                expect(image!.orientation).to(beNil())
                expect(image!.type).to(beNil())
                expect(image!.url).to(beNil())
                expect(image!.width).toNot(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let image = Image(json: ImageJSON.empty())
                
                expect(image).to(beNil())
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
        static func valid() -> Any {
            return [
                "url": ImageJSON.url,
                "height": ImageJSON.height,
                "width": ImageJSON.width,
                "orientation": ImageJSON.orientation,
                "type": ImageJSON.type
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "width": ImageJSON.width
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
