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
                let json = MediaJSON.valid()
                let result = json.decode(Media.self)
                
                expect(result).toNot(beNil())
                expect(result?.mediaId).toNot(beNil())
                expect(result?.name).toNot(beNil())
                expect(result?.drm).toNot(beNil())
                expect(result?.format).toNot(beNil())
                expect(result?.height).toNot(beNil())
                expect(result?.width).toNot(beNil())
                expect(result?.durationMillis).toNot(beNil())
                expect(result?.programId).toNot(beNil())
                expect(result?.status).toNot(beNil())
            }
            
            it("should init with partial response") {
                let json = MediaJSON.missingKeys()
                let result = json.decode(Media.self)
                
                expect(result).toNot(beNil())
                expect(result?.mediaId).to(beNil())
                expect(result?.name).to(beNil())
                expect(result?.drm).to(beNil())
                expect(result?.format).toNot(beNil())
                expect(result?.height).to(beNil())
                expect(result?.width).to(beNil())
                expect(result?.durationMillis).to(beNil())
                expect(result?.programId).to(beNil())
                expect(result?.status).to(beNil())
            }
            
            it("should init with empty response") {
                let json = MediaJSON.empty()
                let result = json.decode(Media.self)
                
                expect(result).toNot(beNil())
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
        
        static func valid() -> [String: Any] {
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
        
        static func missingKeys() -> [String: Any] {
            return [
                "format": MediaJSON.format
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
    }
}
