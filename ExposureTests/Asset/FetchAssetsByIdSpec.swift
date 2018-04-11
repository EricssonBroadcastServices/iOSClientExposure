//
//  FetchAssetsByIdSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-05-15.
//  Copyright © 2017 emp. All rights reserved.
//

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
        
        let assetId = AssetSpec.AssetJSON.assetId
        
        let fetchAsset = FetchAsset(environment: env)
        let fetchReq = fetchAsset.filter(assetId: assetId)
       
        describe("Basics") {
            
            it("should have no headers") {
                expect(fetchReq.headers).to(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/content/asset/" + assetId
                expect(fetchReq.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let params = fetchReq
                    .include(fields: ["first"])
                    .exclude(fields: ["notUsed"])
                    .filter(includeSeasons: true)
                    .filter(includeEpisodes: false)
                    .parameters
                
                expect(params.count).to(equal(7))
                
                expect(params["includeEpisodes"]).toNot(beNil())
                expect(params["includeSeasons"]).toNot(beNil())
                expect(params["fieldSet"]).toNot(beNil())
                expect(params["excludeFields"]).toNot(beNil())
                expect(params["includeFields"]).toNot(beNil())
                expect(params["onlyPublished"]).toNot(beNil())
                expect(params["includeUserData"]).toNot(beNil())
            }
        }
        
        describe("Query params") {
            it("should filter on seasons and episodes") {
                let noSeasons = fetchReq.filter(includeSeasons: false)
                let onlySeasons = noSeasons.filter(includeSeasons: true)
                let seasonsAndEpisodes = onlySeasons.filter(includeEpisodes: true)
                let episodesTurnedOff = seasonsAndEpisodes.filter(includeEpisodes: false)
                let noChangeEpisodes = episodesTurnedOff.filter(includeEpisodes: false)
                let sameValueSeasons = seasonsAndEpisodes.filter(includeSeasons: true)
                
                expect(noSeasons.seasonsIncluded).to(beFalse())
                expect(noSeasons.episodesIncluded).to(beFalse())
                
                expect(onlySeasons.seasonsIncluded).to(beTrue())
                expect(onlySeasons.episodesIncluded).to(beFalse())
                
                expect(seasonsAndEpisodes.seasonsIncluded).to(beTrue())
                expect(seasonsAndEpisodes.episodesIncluded).to(beTrue())
                
                expect(episodesTurnedOff.seasonsIncluded).to(beTrue())
                expect(episodesTurnedOff.episodesIncluded).to(beFalse())
                
                expect(noChangeEpisodes.seasonsIncluded).to(beTrue())
                expect(noChangeEpisodes.episodesIncluded).to(beFalse())
                
                expect(sameValueSeasons.seasonsIncluded).to(beTrue())
                expect(sameValueSeasons.episodesIncluded).to(beTrue())
            }
            
            it("should include fieldSets") {
                let empty = fetchReq.use(fieldSet: .empty)
                let partial = empty.use(fieldSet: .partial)
                let all = empty.use(fieldSet: .all)
                
                expect(self.compare(field: empty.fieldSet, to: .empty)).to(beTrue())
                expect(self.compare(field: partial.fieldSet, to: .partial)).to(beTrue())
                expect(self.compare(field: all.fieldSet, to: .all)).to(beTrue())
            }
            
            it("should include fields") {
                expect(fetchReq.fieldsIncluded).to(beNil())
                let fields = ["ONE", "TWO"]
                let withField = fetchReq.include(fields: fields)
                expect(withField.fieldsIncluded).to(contain(fields))
            }
            
            it("should filter on excluded fields") {
                expect(fetchReq.fieldsExcluded).to(beNil())
                let fields = ["ONE", "TWO"]
                let withField = fetchReq.exclude(fields: fields)
                expect(withField.fieldsExcluded).to(contain(fields))
            }
            
            it("should filter on publishedOnly") {
                expect(fetchReq.onlyPublished).to(beTrue())
                let unpublished = fetchReq.filter(onlyPublished: false)
                expect(unpublished.onlyPublished).to(beFalse())
            }
        }
    }
    
    func compare(field: FetchAssetById.FieldSet, to other: FetchAssetById.FieldSet) -> Bool {
        switch (field, other) {
        case (.empty, .empty): return true
        case (.partial, .partial): return true
        case (.all, .all): return true
        default: return false
        }
    }
}



