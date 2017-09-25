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
                let json: [String: Codable] = [
                    "httpCode":404
                ]
                
                let result = json.decode(ExposureResponseMessage.self)
                
                expect(result).to(beNil())
            }
            
            it("should not initialize with invalid fields") {
                let json: [String: Codable] = [
                    "httpCode":"invalid",
                    "message":"a message"
                ]
                
                let result = json.decode(ExposureResponseMessage.self)
                
                expect(result).to(beNil())
            }
        }
    }
}
