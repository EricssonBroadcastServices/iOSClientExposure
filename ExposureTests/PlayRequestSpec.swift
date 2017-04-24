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
                let playRequest = PlayRequest().toJSON()
                
                let drm: String? = playRequest["drm"] as? String
                let format: String? = playRequest["format"] as? String
                
                expect(drm).toNot(beNil())
                expect(format).toNot(beNil())
                expect(drm!).to(equal("UNENCRYPTED"))
                expect(format!).to(equal("HLS"))
            }
        }
    }
}
