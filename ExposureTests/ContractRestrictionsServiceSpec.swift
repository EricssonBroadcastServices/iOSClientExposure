//
//  ContractRestrictionsServiceSpec.swift
//  ExposureTests
//
//  Created by Fredrik Sjöberg on 2018-01-29.
//  Copyright © 2018 emp. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import Exposure

class ContractRestrictionsServiceSpec: ProgramProvider {
    override func spec() {
        super.spec()
        
        describe("ContractRestrictionsService") {
            let service = ContractRestrictionsService()
            let entitmelent 
            it("should convey restrictions from entitlement") {
                let noneEnabled = self.buildEntitlement(ffEnabled: false, rwEnabled: false, timeshiftEnabled: false)
                
                let ff = service.canSeek(from: 0, to: 10, using: noneEnabled)
                let rw = service.canSeek(from: 10, to: 0, using: noneEnabled)
                let pause = service.canPause(entitlement: noneEnabled)
                
                expect(ff).to
            }
        }
    }
    
    
    func buildEntitlement(ffEnabled: Bool = true, rwEnabled: Bool = true, timeshiftEnabled: Bool = true) -> PlaybackEntitlement {
        return PlaybackEntitlement(playTokenExpiration: "playTokenExpiration", mediaLocator: URL(string: "http://www.example.com")!, playSessionId: "playSessionId", live: false, ffEnabled: ffEnabled, timeshiftEnabled: timeshiftEnabled, rwEnabled: rwEnabled, airplayBlocked: false, playToken: nil, fairplay: nil, licenseExpiration: nil, licenseExpirationReason: nil, licenseActivation: nil, entitlementType: nil, minBitrate: nil, maxBitrate: nil, maxResHeight: nil, mdnRequestRouterUrl: nil, lastViewedOffset: nil, lastViewedTime: nil, liveTime: nil, productId: nil)
    }
}
