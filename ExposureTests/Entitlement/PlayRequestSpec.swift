//
//  PlayRequestSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-24.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class PlayRequestSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("PlayRequest") {
            it("should convert to json") {
                let playRequest = PlayRequest(drm: "UNENCRYPTED", format: "HLS").toJSON()
                
                let drm: String? = playRequest["drm"] as? String
                let format: String? = playRequest["format"] as? String
                
                expect(drm).toNot(beNil())
                expect(format).toNot(beNil())
                expect(drm!).to(equal("UNENCRYPTED"))
                expect(format!).to(equal("HLS"))
            }
            
            it("should record DRM and format") {
                let playRequest = PlayRequest(drm: "FAIRPLAY", format: "HLS")
                
                let drm = playRequest.drm
                let format = playRequest.format
                
                expect(drm).to(equal("FAIRPLAY"))
                expect(format).to(equal("HLS"))
            }
        }
    }
}
