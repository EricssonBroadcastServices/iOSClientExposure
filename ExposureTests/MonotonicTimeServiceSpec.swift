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
        case errorFirstRequest
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
        case .errorFirstRequest:
            if errors < 4 {
                print("errorFirstRequest ERROR",errors,times.count)
                errors += 1
                callback(nil, ExposureError.generalError(error: MockedError.sampleError))
            }
            else {
                let serverTime = ServerTime(epochMillis: UInt64(Date().millisecondsSince1970), iso8601: nil)
                times.append(serverTime)
                print("errorFirstRequest RECONNECT",errors,times.count,serverTime.epochMillis)
                callback(serverTime, nil)
            }
        }
        
    }
    var times: [ServerTime] = []
    var errors: Int = 0
    
    enum MockedError: Error {
        case sampleError
    }
}

class MonotonicTimeServiceSpec: QuickSpec {
    let environment = Environment(baseUrl: "someUrl", customer: "Customer", businessUnit: "BusinessUnit")
    
    override func spec() {
        super.spec()
        
        
        describe("MonotonicTimeService") {
            
            context("synchronous currentTime") {
                let service = MonotonicTimeService(environment: environment, refreshInterval: 100, errorRetryInterval: 1000)
                let provider = MockedServerTimeProvider()
                service.serverTimeProvider = provider

                it("should return no current time if not started") {
                    expect(service.currentTime).to(beNil())
                }

                it("should eventually return current time when running") {
                    expect(service.currentTime).toEventuallyNot(beNil())
                }
            }

            context("sync fails") {
                let service = MonotonicTimeService(environment: environment, refreshInterval: 500, errorRetryInterval: 100)
                let provider = MockedServerTimeProvider()
                service.serverTimeProvider = provider
                provider.mode = .errorFirstRequest
                it("should apply retry interval") {
                    service.currentTime{ time in
                        expect(time).to(beNil())
                    }

                    expect(provider.errors).toEventually(equal(4))
                    expect(provider.times.count).toEventually(equal(1))
                }
            }
            
            context("forcing updates disabled") {
                let service = MonotonicTimeService(environment: environment, refreshInterval: 100, errorRetryInterval: 1000)
                let provider = MockedServerTimeProvider()
                service.serverTimeProvider = provider


                it("should not do network call when no server time is cached") {
                    var times: [Int64] = []
                    service.currentTime{ time in
                        if let time = time {
                            times.append(time)
                        }
                    }

                    service.currentTime(forceRefresh: false) { time in
                        if let time = time {
                            times.append(time)
                        }
                    }

                    expect(provider.times.count).toEventually(equal(5))
                    expect(times.count).toEventually(equal(1))
                }
            }

            context("forcing updates enabled") {
                let service = MonotonicTimeService(environment: environment, refreshInterval: 100, errorRetryInterval: 1000)
                let provider = MockedServerTimeProvider()
                service.serverTimeProvider = provider

                it("should do network call when no server time is cached") {
                    var times: [Int64] = []
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
