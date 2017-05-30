//
//  MediaSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-16.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class MediaSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let value = Media(json: MediaJSON.valid())
                
                expect(value).toNot(beNil())
                expect(value!.mediaId).toNot(beNil())
                expect(value!.name).toNot(beNil())
                expect(value!.drm).toNot(beNil())
                expect(value!.format).toNot(beNil())
                expect(value!.height).toNot(beNil())
                expect(value!.width).toNot(beNil())
                expect(value!.durationMillis).toNot(beNil())
                expect(value!.programId).toNot(beNil())
                expect(value!.status).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let value = Media(json: MediaJSON.missingKeys())
                
                expect(value).toNot(beNil())
                expect(value!.mediaId).to(beNil())
                expect(value!.name).to(beNil())
                expect(value!.drm).to(beNil())
                expect(value!.format).toNot(beNil())
                expect(value!.height).to(beNil())
                expect(value!.width).to(beNil())
                expect(value!.durationMillis).to(beNil())
                expect(value!.programId).to(beNil())
                expect(value!.status).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let value = Media(json: MediaJSON.empty())
                
                expect(value).to(beNil())
            }
        }
    }
}

extension MediaSpec {
    enum MediaJSON {
        static let mediaId = "VU-TITLjonas9-movie_qwerty"
        static let name = "mediaName"
        static let drm = "EDRM"
        static let format = "HLS"
        static let height = 100
        static let width = 100
        static let durationMillis = 100
        static let programId = "programId"
        static let status = "enabled"
        
        static func valid() -> Any {
            return [
                "mediaId": MediaJSON.mediaId,
                "name": MediaJSON.name,
                "drm": MediaJSON.drm,
                "format": MediaJSON.format,
                "height": MediaJSON.height,
                "width": MediaJSON.width,
                "durationMillis": MediaJSON.durationMillis,
                "programId": MediaJSON.programId,
                "status": MediaJSON.status
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "format": MediaJSON.format
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
    }
}
