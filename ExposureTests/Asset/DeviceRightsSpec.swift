//
//  DeviceRightsSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-16.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class DeviceRightsSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let value = DeviceRights(json: DeviceRightsJSON.valid())
                
                expect(value).toNot(beNil())
                expect(value!.type).toNot(beNil())
                expect(value!.model).toNot(beNil())
                expect(value!.manufacturer).toNot(beNil())
                expect(value!.os).toNot(beNil())
                expect(value!.osVersion).toNot(beNil())
                expect(value!.rights).toNot(beNil())
            }
            
            it("should succeed with partial response") {
                let value = DeviceRights(json: DeviceRightsJSON.missingKeys())
                
                expect(value).toNot(beNil())
                expect(value!.type).toNot(beNil())
                expect(value!.model).to(beNil())
                expect(value!.manufacturer).to(beNil())
                expect(value!.os).to(beNil())
                expect(value!.osVersion).to(beNil())
                expect(value!.rights).to(beNil())
            }
            
            it("should not init with empty or non matching response") {
                let value = DeviceRights(json: DeviceRightsJSON.empty())
                
                expect(value).to(beNil())
            }
            
            it("should init with missformed assetRights") {
                let value = DeviceRights(json: DeviceRightsJSON.missformatedAssetRights())
                
                expect(value).toNot(beNil())
                expect(value!.type).toNot(beNil())
                expect(value!.model).to(beNil())
                expect(value!.manufacturer).to(beNil())
                expect(value!.os).to(beNil())
                expect(value!.osVersion).to(beNil())
                expect(value!.rights).to(beNil())
            }
        }
        
        describe("DeviceType") {
            it("should init properly") {
                let web = DeviceType(string: "WEB")
                let mobile = DeviceType(string: "MOBILE")
                let tablet = DeviceType(string: "TABLET")
                let appleTv = DeviceType(string: "APPLE_TV")
                let smartTv = DeviceType(string: "SMART_TV")
                let console = DeviceType(string: "CONSOLE")
                let stb = DeviceType(string: "STB")
                let other = DeviceType(string: "Unkown or new type")
                
                expect(self.test(value: web, against: DeviceType.web)).to(beTrue())
                expect(self.test(value: mobile, against: DeviceType.mobile)).to(beTrue())
                expect(self.test(value: tablet, against: DeviceType.tablet)).to(beTrue())
                expect(self.test(value: appleTv, against: DeviceType.appleTv)).to(beTrue())
                expect(self.test(value: smartTv, against: DeviceType.smartTv)).to(beTrue())
                expect(self.test(value: console, against: DeviceType.console)).to(beTrue())
                expect(self.test(value: stb, against: DeviceType.stb)).to(beTrue())
                expect(self.test(value: other, against: DeviceType.other(string: "Unkown or new type"))).to(beTrue())
                expect(self.test(value: other, against: DeviceType.other(string: "Not Matching"))).to(beFalse())
                
            }
        }
    }
    
    func test(value: DeviceType, against: DeviceType) -> Bool {
        switch (value, against) {
        case (.web, .web): return true
        case (.mobile, .mobile): return true
        case (.tablet, .tablet): return true
        case (.appleTv, .appleTv): return true
        case (.smartTv, .smartTv): return true
        case (.console, .console): return true
        case (.stb, .stb): return true
        case (.other(let first), .other(let second)): return first == second
        default: return false
        }
    }
}

extension DeviceRightsSpec {
    enum DeviceRightsJSON {
        static let type = "MOBILE"
        static let model = "iPhone1,1"
        static let manufacturer = "Apple"
        static let os = "iOS"
        static let osVersion = "iOS10.0"
        static let rights = AssetRightsSpec.AssetRightsJSON.valid()
        static func valid() -> Any {
            return [
                "type": DeviceRightsJSON.type,
                "model": DeviceRightsJSON.model,
                "manufacturer": DeviceRightsJSON.manufacturer,
                "os": DeviceRightsJSON.os,
                "osVersion": DeviceRightsJSON.osVersion,
                "rights": DeviceRightsJSON.rights
            ]
        }
        
        static func missingKeys() -> Any {
            return [
                "type": DeviceRightsJSON.type
            ]
        }
        
        static func empty() -> Any {
            return [:]
        }
        
        static func missformatedAssetRights() -> Any {
            return [
                "type": DeviceRightsJSON.type,
                "rights": []
            ]
        }
    }
}
