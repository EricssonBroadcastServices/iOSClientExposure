//
//  FetchAssetsByIdSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Exposure

class FetchAssetByIdSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        
        let assetId = "players_test_asset_ADS_Ocean_009_qwerty"//"VU-21702_qwerty"
        /*
        let t = FetchAsset(environment: env)
            .filter(assetId: assetId)
            .filter(seasons: true)
            .request()
            .response { (data: ExposureResponse<Asset>) in
                if let value = data.value {
                    
                    print(value)
                    
                }
                else {
                    print(data.error)
                }
        }*/
        
        describe("FetchAssetById") {
            it("should init with complete json") {
                
            }
        }
    }
}



