//
//  ExposureErrorSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-13.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import iOSClientExposure

class ExposureErrorSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("ExposureError") {
            it("should describe object error") {
                let reason = ExposureError.serialization(reason: ExposureError.SerializationFailureReason.objectSerialization(reason: "REASON", json: [:]))
                
                let desc = reason.message
                
                expect(desc).to(equal("OBJECT_SERIALIZATION_ERROR"))
            }
            
            it("should describe jsonSerialization error") {
                let anyError = NSError(domain: "domain", code: 1, userInfo: nil)
                let reason = ExposureError.serialization(reason: ExposureError.SerializationFailureReason.jsonSerialization(error: anyError))
                
                let desc = reason.message
                
                expect(desc).to(equal("JSON_SERIALIZATION_ERROR"))
            }
            
            it("should have an error domain") {
                let error = ExposureError.exposureResponse(reason: ExposureResponseMessage(httpCode: 10, message: "ERROR", actions: nil))
                expect(error.domain).to(equal(String(describing: type(of: error))+"Domain"))
            }
        }
    }
}
