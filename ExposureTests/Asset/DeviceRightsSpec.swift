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
    
    typealias DeviceRights = Asset.DeviceRights
    typealias DeviceRightsType = Asset.DeviceRights.DeviceRightsType
    
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
        
        describe("DeviceRightsType") {
            it("should init properly") {
                let web = DeviceRightsType(string: "WEB")
                let mobile = DeviceRightsType(string: "MOBILE")
                let tablet = DeviceRightsType(string: "TABLET")
                let appleTv = DeviceRightsType(string: "APPLE_TV")
                let smartTv = DeviceRightsType(string: "SMART_TV")
                let console = DeviceRightsType(string: "CONSOLE")
                let stb = DeviceRightsType(string: "STB")
                let other = DeviceRightsType(string: "Unkown or new type")
                
                expect(self.test(value: web, against: DeviceRightsType.web)).to(beTrue())
                expect(self.test(value: mobile, against: DeviceRightsType.mobile)).to(beTrue())
                expect(self.test(value: tablet, against: DeviceRightsType.tablet)).to(beTrue())
                expect(self.test(value: appleTv, against: DeviceRightsType.appleTv)).to(beTrue())
                expect(self.test(value: smartTv, against: DeviceRightsType.smartTv)).to(beTrue())
                expect(self.test(value: console, against: DeviceRightsType.console)).to(beTrue())
                expect(self.test(value: stb, against: DeviceRightsType.stb)).to(beTrue())
                expect(self.test(value: other, against: DeviceRightsType.other(string: "Unkown or new type"))).to(beTrue())
                expect(self.test(value: other, against: DeviceRightsType.other(string: "Not Matching"))).to(beFalse())
                
            }
        }
    }
    
    func test(value: DeviceRightsType, against: DeviceRightsType) -> Bool {
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
