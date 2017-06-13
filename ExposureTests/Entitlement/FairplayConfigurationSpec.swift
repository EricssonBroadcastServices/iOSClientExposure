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
                    
                    let json = [
                        "secondaryMediaLocator":"foo",
                        "certificateUrl":"bar",
                        "licenseAcquisitionUrl":"baz"
                    ]
                    
                    let config = FairplayConfiguration(json: json)
                    expect(config).toNot(beNil())
                    expect(config?.secondaryMediaLocator).toNot(beNil())
                    expect(config?.certificateUrl).toNot(beNil())
                    expect(config?.licenseAcquisitionUrl).toNot(beNil())
                    
                    expect(config?.secondaryMediaLocator!).to(equal("foo"))
                    expect(config?.certificateUrl!).to(equal("bar"))
                    expect(config?.licenseAcquisitionUrl!).to(equal("baz"))
                }
            }
            
            context("Failure") {
                it("should fail to init without all fields present") {
                    let json = [
                        "secondaryMediaLocator":"foo",
                        "certificateUrl":"bar"
                    ]
                    
                    let config = FairplayConfiguration(json: json)
                    expect(config).to(beNil())
                }
            }
        }
        
    }
}
