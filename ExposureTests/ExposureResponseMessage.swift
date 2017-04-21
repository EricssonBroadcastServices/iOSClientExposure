//
//  ExposureResponseMessage.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-21.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class ExposureResponseMessageSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("ExposureResponseMessage") {
            it("should not initialize with missing fields") {
                let json = [
                    "httpCode":404
                ]
                let message = ExposureResponseMessage(json: json)
                expect(message).to(beNil())
            }
            
            it("should not initialize with invalid fields") {
                let json = [
                    "httpCode":"invalid",
                    "message":"a message"
                ]
                let message = ExposureResponseMessage(json: json)
                expect(message).to(beNil())
            }
        }
    }
}
