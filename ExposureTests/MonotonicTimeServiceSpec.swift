//
//  MonotonicTimeServiceSpec.swift
//  ExposureTests
//
//  Created by Fredrik Sjöberg on 2018-01-08.
//  Copyright © 2018 emp. All rights reserved.
//

import Quick
import Nimble

import Foundation

@testable import Exposure

class MockedServerTimeProvider: ServerTimeProvider {
    var mode: Mode = .delayFirstRequest(first: true)
    enum Mode {
        case delayFirstRequest(first: Bool)
    }
    
    func fetchServerTime(using environment: Environment, callback: @escaping (ServerTime?, ExposureError?) -> Void) {
        switch mode {
        case .delayFirstRequest(first: let first):
            if first {
                mode = .delayFirstRequest(first: false)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(150)) {
                    let serverTime = ServerTime(epochMillis: UInt64(Date().millisecondsSince1970), iso8601: nil)
                    print("fetchServerTime delay",serverTime.epochMillis)
                    self.times.append(serverTime)
                    callback(serverTime, nil)
                }
            }
            else {
                let serverTime = ServerTime(epochMillis: UInt64(Date().millisecondsSince1970), iso8601: nil)
                print("fetchServerTime","[\(times.count)]",serverTime.epochMillis)
                times.append(serverTime)
                callback(serverTime, nil)
            }
        }
        
    }
    var times: [ServerTime] = []
}

class MonotonicTimeServiceSpec: QuickSpec {
    let environment = Environment(baseUrl: "someUrl", customer: "Customer", businessUnit: "BusinessUnit")
    
    override func spec() {
        super.spec()
        
        
        describe("MonotonicTimeService") {
            
            context("forcing updates disabled") {
                let service = MonotonicTimeService(environment: environment, refreshInterval: 100, errorRetryInterval: 1000)
                let provider = MockedServerTimeProvider()
                service.serverTimeProvider = provider
                
                var otherTimes: [Int64] = []
                it("should not do network call when no server time is cached") {
                    service.currentTime{ time in
                        if let time = time {
                            otherTimes.append(time)
                        }
                    }
                    
                    service.currentTime(forceRefresh: false) { time in
                        if let time = time {
                            otherTimes.append(time)
                        }
                    }
                    
                    expect(provider.times.count).toEventually(equal(5))
                    expect(otherTimes.count).toEventually(equal(1))
                }
            }

            context("forcing updates enabled") {
                let service = MonotonicTimeService(environment: environment, refreshInterval: 100, errorRetryInterval: 1000)
                let provider = MockedServerTimeProvider()
                service.serverTimeProvider = provider

                var times: [Int64] = []
                it("should do network call when no server time is cached") {
                    service.currentTime{ time in
                        if let time = time {
                            times.append(time)
                        }
                    }

                    service.currentTime(forceRefresh: true) { time in
                        if let time = time {
                            times.append(time)
                        }
                    }

                    expect(provider.times.count).toEventually(equal(5))
                    expect(times.count).toEventually(equal(2))
                }
            }

            
        }
    }
}
