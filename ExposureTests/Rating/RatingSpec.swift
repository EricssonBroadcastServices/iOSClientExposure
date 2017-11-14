//
//  RatingSpec.swift
//  ExposureTests
//
//  Created by Fredrik Sjöberg on 2017-11-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation


import Quick
import Nimble
import Mockingjay

@testable import Exposure

class RatingSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        let sessionToken = SessionToken(value: "Token")
        
        let query = "query"
        let request = Rating(environment: env, sessionToken: sessionToken)
        let assetId = "assetId"
        
        describe("FetchRating") {
            let rating = request.rating(for: assetId)
            
            it("should have no headers") {
                expect(rating.headers).toNot(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/rating/asset/" + assetId
                expect(rating.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let params = rating.parameters
                expect(params.count).to(equal(0))
            }
        }
        
        describe("FetchRatingsList") {
            let rating = request.list()
            
            it("should have no headers") {
                expect(rating.headers).toNot(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/rating/asset/all"
                expect(rating.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let params = rating.parameters
                expect(params.count).to(equal(0))
            }
        }
        
        describe("FetchAllRating") {
            let rating = request.allRatings(for: assetId)
            
            it("should have no headers") {
                expect(rating.headers).toNot(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/rating/asset/" + assetId + "/all"
                expect(rating.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let params = rating.parameters
                expect(params.count).to(equal(0))
            }
        }
        
        describe("PostRating") {
            let rating = request.rate(assetId: assetId, to: 1)
            
            it("should have no headers") {
                expect(rating.headers).toNot(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/rating/asset/" + assetId
                expect(rating.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let params = rating.parameters
                expect(params.count).to(equal(1))
            }
        }
        
        describe("DeleteRating") {
            let rating = request.rate(assetId: assetId, to: 1)
            
            it("should have no headers") {
                expect(rating.headers).toNot(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/rating/asset/" + assetId
                expect(rating.endpointUrl).to(equal(env.apiUrl+endpoint))
            }
            
            it("should generate paramters") {
                let params = rating.parameters
                expect(params.count).to(equal(0))
            }
        }
    }
}
