//
//  ExposureSpec.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-04-24.
//  Copyright © 2017 emp. All rights reserved.
//

import Quick
import Nimble

@testable import Exposure

struct ExposureTestRequest: ExposureType {
    typealias Response = Credentials
    
    var endpointUrl: String {
        return "fakeEndpoint"
    }
    
    var parameters: [String: Any]? {
        return ["some":"params"]
    }
    
    var headers: [String: String]? {
        return nil
    }
}

extension ExposureTestRequest {
    func request() -> ExposureRequest<Response>{
        return request(.get)
    }
}


class ExposureSpec: QuickSpec {
    override func spec() {
        super.spec()
        
        describe("Exposure") {
            it("should forward optional parameters") {
                let request = ExposureTestRequest()
                    .request()
                
                let urlRequest = request.dataRequest.request
                expect(urlRequest).toNot(beNil())
                expect(urlRequest!.httpBody).toNot(beNil())
            }
        }
    }
}
