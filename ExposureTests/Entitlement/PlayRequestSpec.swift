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
