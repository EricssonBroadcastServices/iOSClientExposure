//
//  FairplayConfigurationSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-21.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class FairplayConfigurationSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("FairplayConfiguration") {
            context("Success") {
                it("should init with correct information") {
                    
                    let json: [String: Codable] = [
                        "secondaryMediaLocator":"foo",
                        "certificateUrl":"bar",
                        "licenseAcquisitionUrl":"baz"
                    ]
                    
                    let result = json.decode(FairplayConfiguration.self)
                    
                    expect(result).toNot(beNil())
                    expect(result?.secondaryMediaLocator).toNot(beNil())
                    expect(result?.certificateUrl).toNot(beNil())
                    expect(result?.licenseAcquisitionUrl).toNot(beNil())
                    
                    expect(result?.secondaryMediaLocator).to(equal("foo"))
                    expect(result?.certificateUrl).to(equal("bar"))
                    expect(result?.licenseAcquisitionUrl).to(equal("baz"))
                }
                
                it("should init with required information") {
                    
                    let json: [String: Codable] = [
                        "certificateUrl":"bar",
                        "licenseAcquisitionUrl":"baz"
                    ]
                    
                    let result = json.decode(FairplayConfiguration.self)
                    
                    expect(result).toNot(beNil())
                    expect(result?.certificateUrl).toNot(beNil())
                    expect(result?.licenseAcquisitionUrl).toNot(beNil())
                    
                    expect(result?.certificateUrl).to(equal("bar"))
                    expect(result?.licenseAcquisitionUrl).to(equal("baz"))
                }
            }
            
            context("Failure") {
                it("should fail to init without all fields present") {
                    let json: [String: Codable] = [
                        "secondaryMediaLocator":"foo",
                        "certificateUrl":"bar"
                    ]
                    expect{ try json.throwingDecode(FairplayConfiguration.self) }
                        .to(throwError(errorType: DecodingError.self))
                }
            }
        }
        
    }
}
