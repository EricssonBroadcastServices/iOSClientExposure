//
//  DeviceInfoSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-20.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

class DeviceInfoSpec: QuickSpec {
    override func spec() {
        describe("DeviceInfo") {
            let device = DeviceInfo.Device(name: "deviceName")
            let deviceInfo = DeviceInfo(device: device)
            
            it("should generate correct JSON") {
                let deviceInfoJson = deviceInfo.toJSON()
                let deviceJson = device.toJSON()
                
                expect(deviceInfoJson["device"]).toNot(beNil())
                
                let height = deviceJson["height"] as? Int
                let width = deviceJson["width"] as? Int
                let model = deviceJson["model"] as? String
                let name = deviceJson["name"] as? String
                let os = deviceJson["os"] as? String
                let manufacturer = deviceJson["manufacturer"] as? String
                let type = deviceJson["type"] as? String
                
                expect(height).toNot(beNil())
                expect(width).toNot(beNil())
                expect(model).toNot(beNil())
                expect(name).toNot(beNil())
                expect(os).toNot(beNil())
                
                expect(manufacturer).toNot(beNil())
                expect(type).toNot(beNil())
            }
        }
    }
}
