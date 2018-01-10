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
                    self.times.append(serverTime)
                    callback(serverTime, nil)
                }
            }
            else {
                let serverTime = ServerTime(epochMillis: UInt64(Date().millisecondsSince1970), iso8601: nil)
                times.append(serverTime)
                callback(serverTime, nil)
            }
        case .errorFirstRequest:
            if errors < 4 {
                errors += 1
                callback(nil, ExposureError.generalError(error: MockedError.sampleError))
            }
            else {
                let serverTime = ServerTime(epochMillis: UInt64(Date().millisecondsSince1970), iso8601: nil)
                times.append(serverTime)
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
                let service = MonotonicTimeService(environment: environment, refreshInterval: 500)
                service.onErrorPolicy = .retry(attempts: 5, interval: 100)
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
                it("should apply retry policy if active") {
                    let service = MonotonicTimeService(environment: self.environment, refreshInterval: 500)
                    service.onErrorPolicy = .retry(attempts: 2, interval: 100)
                    let provider = MockedServerTimeProvider()
                    service.serverTimeProvider = provider
                    provider.mode = .errorFirstRequest

                    service.currentTime{ time, error in
                        expect(time).to(beNil())
                    }

                    expect(provider.errors).toEventually(equal(2))
                    expect(provider.times.count).toEventually(equal(1))
                }

                it("should retain default refresh policy if active") {
                    let service = MonotonicTimeService(environment: self.environment, refreshInterval: 500)
                    service.onErrorPolicy = .retainRefreshInterval
                    let provider = MockedServerTimeProvider()
                    service.serverTimeProvider = provider
                    provider.mode = .errorFirstRequest

                    service.currentTime{ time, error in
                        expect(time).to(beNil())
                    }

                    expect(provider.errors).toEventually(equal(2))
                    expect(provider.times.count).toEventually(equal(0))
                }
            }

            context("forcing updates disabled") {
                it("should not do network call when no server time is cached") {
                    let service = MonotonicTimeService(environment: self.environment, refreshInterval: 100)
                    service.onErrorPolicy = .retry(attempts: 5, interval: 100)
                    let provider = MockedServerTimeProvider()
                    service.serverTimeProvider = provider

                    var times: [Int64] = []
                    service.currentTime{ time, error in
                        if let time = time {
                            times.append(time)
                        }
                    }

                    service.currentTime(forceRefresh: false) { time, error in
                        if let time = time {
                            times.append(time)
                        }
                    }

                    expect(provider.times.count).toEventually(equal(5))
                    expect(times.count).toEventually(equal(1))
                }
            }

            context("forcing updates enabled") {
                let service = MonotonicTimeService(environment: environment, refreshInterval: 100)
                service.onErrorPolicy = .retry(attempts: 5, interval: 100)
                let provider = MockedServerTimeProvider()
                service.serverTimeProvider = provider

                it("should do network call when no server time is cached") {
                    var times: [Int64] = []
                    service.currentTime{ time, error in
                        if let time = time {
                            times.append(time)
                        }
                    }

                    service.currentTime(forceRefresh: true) { time, error in
                        if let time = time {
                            times.append(time)
                        }
                    }

                    expect(provider.times.count).toEventually(equal(5))
                    expect(times.count).toEventually(equal(2))
                }
            }
        }

        describe("MonotonicTimeService Difference") {
            let tolerance: Int64 = 210
            let date = Date().millisecondsSince1970
            let difference = MonotonicTimeService.Difference(serverStartTime: date + 400, localStartTime: date + 200)
            let monotonicTime = difference.monotonicTime
            it("should calculate servertime within reasonable bounds") {
                expect(monotonicTime).to(beGreaterThan(date-tolerance))
                expect(monotonicTime).to(beLessThan(date+tolerance))
            }
        }
    }
}
