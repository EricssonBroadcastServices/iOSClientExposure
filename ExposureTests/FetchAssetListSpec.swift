//
//  FetchAssetListSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-24.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay

@testable import Exposure

class FetchAssetListSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        
        let assetResponse = AssetListSpec.AssetListJSON.valid()
        
        let fetchAsset = FetchAsset(environment: env)
        let fetchList = fetchAsset.list()
        
        describe("Basics") {
            
            it("should have no headers") {
                expect(fetchList.headers).to(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/content/asset"
                expect(fetchList.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let params = fetchList
                    .include(fields: ["first"])
                    .exclude(fields: ["notUsed"])
                    .filter(onlyPublished: true)
                    .show(page: 1, spanning: 10)
                    .filter(on: .episode)
                    .filter(on: .mobile)
                    .parameters
                
                expect(params.count).to(equal(8))
                
                expect(params["onlyPublished"]).toNot(beNil())
                expect(params["fieldSet"]).toNot(beNil())
                expect(params["excludeFields"]).toNot(beNil())
                expect(params["includeFields"]).toNot(beNil())
                expect(params["pageSize"]).toNot(beNil())
                expect(params["pageNumber"]).toNot(beNil())
                expect(params["assetType"]).toNot(beNil())
                expect(params["deviceType"]).toNot(beNil())
            }
        }
        
        describe("PageableResponse") {
            it("should record page size and number") {
                let size = fetchList.show(page: 1)
                
                expect(size.pageNumber).to(equal(1))
                expect(size.pageSize).to(equal(50))
                
                let modified = size.show(page: 2, spanning: 10)
                
                expect(modified.pageNumber).to(equal(2))
                expect(modified.pageSize).to(equal(10))
            }
        }
    }
}
