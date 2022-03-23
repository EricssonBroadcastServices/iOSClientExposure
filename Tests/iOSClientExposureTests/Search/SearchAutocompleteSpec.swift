//
//  SearchAutocompleteSpec.swift
//  ExposureTests
//
//  Created by Fredrik Sjöberg on 2017-10-15.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import iOSClientExposure

class SearchAutocompleteSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let base = "https://exposure.empps.ebsd.ericsson.net"
        let customer = "BlixtGroup"
        let businessUnit = "Blixt"
        let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)
        
        let query = "query"
        let request = Search(environment: env).autocomplete(for: query)
        
        describe("Basics") {
            
            it("should have no headers") {
                expect(request.headers).to(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/content/search/autocomplete/" + query
                expect(request.endpointUrl).to(equal(env.apiUrl + endpoint))
            }

            it("should generate paramters if specified") {
                let params = request
                    .filter(locale: "en")
                    .parameters
                
                expect(params).toNot(beNil())
                expect(params?.count).to(equal(1))
                
                expect(params?["locale"]).toNot(beNil())
            }
            
            it("should not generate paramters if not specified") {
                let params = request
                    .parameters
                
                expect(params).to(beNil())
            }
        }
    }
}
