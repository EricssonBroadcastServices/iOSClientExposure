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
import Mockingjay

@testable import Exposure

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
                expect(fetchList.headers).to(beNil())
            }
            
            it("should generate a correct endpoint url") {
                let endpoint = "/content/search/autocomplete/" + query
                expect(fetchList.endpointUrl).to(equal(env.apiUrl + endpoint))
            }

            it("should generate paramters") {
                let params = fetchList
                    .filter(locale: "en")
                    .parameters
                
                expect(params.count).to(equal(1))
                
                expect(params["locale"]).toNot(beNil())
            }
        }
    }
}
