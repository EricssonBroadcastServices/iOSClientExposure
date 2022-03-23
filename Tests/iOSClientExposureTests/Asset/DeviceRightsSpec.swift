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

@testable import iOSClientExposure

class DeviceRightsSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("JSON") {
            it("should succeed with valid response") {
                let json = DeviceRightsJSON.valid()
                let result = json.decode(DeviceRights.self)
                
                expect(result).toNot(beNil())
                expect(result?.type).toNot(beNil())
                expect(result?.model).toNot(beNil())
                expect(result?.manufacturer).toNot(beNil())
                expect(result?.os).toNot(beNil())
                expect(result?.osVersion).toNot(beNil())
                expect(result?.rights).toNot(beNil())
            }
            
            it("should init with partial response") {
                let json = DeviceRightsJSON.missingKeys()
                let result = json.decode(DeviceRights.self)
                
                expect(result).toNot(beNil())
                expect(result?.type).toNot(beNil())
                expect(result?.model).to(beNil())
                expect(result?.manufacturer).to(beNil())
                expect(result?.os).to(beNil())
                expect(result?.osVersion).to(beNil())
                expect(result?.rights).to(beNil())
            }
            
            it("should init with empty response") {
                let json = DeviceRightsJSON.empty()
                let result = json.decode(DeviceRights.self)
                
                expect(result).toNot(beNil())
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
                
                expect(self.test(value: mobile, against: DeviceType.mobile)).to(beTrue())
                expect(self.test(value: tablet, against: DeviceType.tablet)).to(beTrue())
                expect(self.test(value: appleTv, against: DeviceType.appleTv)).to(beTrue())
                expect(self.test(value: other, against: DeviceType.other(string: "Unkown or new type"))).to(beTrue())
                expect(self.test(value: other, against: DeviceType.other(string: "Not Matching"))).to(beFalse())
                
            }
        }
    }
    
    func test(value: DeviceType, against: DeviceType) -> Bool {
        switch (value, against) {
        case (.mobile, .mobile): return true
        case (.tablet, .tablet): return true
        case (.appleTv, .appleTv): return true
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
        static func valid() -> [String: Any] {
            return [
                "type": DeviceRightsJSON.type,
                "model": DeviceRightsJSON.model,
                "manufacturer": DeviceRightsJSON.manufacturer,
                "os": DeviceRightsJSON.os,
                "osVersion": DeviceRightsJSON.osVersion,
                "rights": DeviceRightsJSON.rights
            ]
        }
        
        static func missingKeys() -> [String: Any] {
            return [
                "type": DeviceRightsJSON.type
            ]
        }
        
        static func empty() -> [String: Any] {
            return [:]
        }
        
        static func missformatedAssetRights() -> [String: Any] {
            return [
                "type": DeviceRightsJSON.type,
                "rights": []
            ]
        }
    }
}
