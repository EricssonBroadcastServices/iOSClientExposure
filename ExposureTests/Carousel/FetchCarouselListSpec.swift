//
//  FetchCarouselListSpec.swift
//  ExposureTests
//
//  Created by Viktor Gardart on 2017-10-04.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay

@testable import Exposure

class FetchCarouselListSpec: QuickSpec {

  override func spec() {
    super.spec()

    let base = "https://exposure.empps.ebsd.ericsson.net"
    let customer = "BlixtGroup"
    let businessUnit = "Blixt"
    let env = Environment(baseUrl: base, customer: customer, businessUnit: businessUnit)

    let groupId = "abc123"

    let fetchList = FetchCarouselList(groupId: groupId,
                                      environment: env)

    describe("Basics") {

      it("should have no headers") {
        expect(fetchList.headers).to(beNil())
      }

      it("should generate a correct endpoint url") {
        let endpoint = "/carouselgroup/" + groupId
        expect(fetchList.endpointUrl).to(equal(env.apiUrl + endpoint))
      }

    }

  }
}

