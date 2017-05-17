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
import Mockingjay

@testable import Exposure

class FetchAssetByIdSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        
        let assetResponse = AssetSpec.AssetJSON.valid()
        
        let fetchAsset = FetchAsset(environment: env)
        let fetchReq = fetchAsset.filter(assetId: AssetSpec.AssetJSON.assetId)
       
        describe("Query params") {
            it("should record query params correctly") {
                let noSeasons = fetchReq.filter(includeSeasons: false)
                let onlySeasons = noSeasons.filter(includeSeasons: true)
                let seasonsAndEpisodes = onlySeasons.filter(includeEpisodes: true)
                
                expect(noSeasons.seasonsIncluded).to(beFalse())
                expect(noSeasons.episodesIncluded).to(beFalse())
                
                expect(onlySeasons.seasonsIncluded).to(beTrue())
                expect(onlySeasons.episodesIncluded).to(beFalse())
                
                expect(seasonsAndEpisodes.seasonsIncluded).to(beTrue())
                expect(seasonsAndEpisodes.episodesIncluded).to(beTrue())
            }
        }
        
        describe("FetchAssetById Response") {
            var request: URLRequest?
            var response: URLResponse?
            var data: Data?
            var asset: Asset?
            var error: Error?
            
            self.stub(uri(fetchReq.endpointUrl), json(assetResponse))
                
            FetchAsset(environment: env)
                .filter(assetId: AssetSpec.AssetJSON.assetId)
                .request()
                .response{ (exposureResponse: ExposureResponse<Asset>) in
                    print("===================")
                    request = exposureResponse.request
                    response = exposureResponse.response
                    data = exposureResponse.data
                    asset = exposureResponse.value
                    error = exposureResponse.error
            }
            
            it("should eventually return a response") {
                
                expect(request).toEventuallyNot(beNil())
                expect(response).toEventuallyNot(beNil())
                expect(data).toEventuallyNot(beNil())
                expect(asset).toEventuallyNot(beNil())
                expect(error).toEventually(beNil())
                
                expect(asset!.assetId).toEventually(equal(AssetSpec.AssetJSON.assetId))
            }
        }
    }
}



