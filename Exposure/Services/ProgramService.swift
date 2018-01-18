//
//  ProgramService.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-01-10.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

internal protocol ProgramProvider {
    func fetchProgram(on channelId: String, timestamp: Int64, using environment: Environment, callback: @escaping (Program?, ExposureError?) -> Void)
    func validate(entitlementFor assetId: String, environment: Environment, sessionToken: SessionToken, callback: @escaping (EntitlementValidation?, ExposureError?) -> Void)
}

internal class ProgramService {
    /// `Environment` to use when requesting program data
    fileprivate var environment: Environment
    
    fileprivate var sessionToken: SessionToken
    
    /// The channel to monitor
    fileprivate let channelId: String
    
    /// Queue where `timer` runs
    fileprivate let queue: DispatchQueue
    
    fileprivate var timer: DispatchSourceTimer?
    
    fileprivate let refreshInterval: Int = 1000 * 3
    
    internal var currentPlayheadTime: () -> Int64? = { _ in return nil }
    internal var onNotEntitled: () -> Void = { _ in}
    internal var onProgramChanged: (Program) -> Void = { _ in }
    
    fileprivate var activeProgram: Program?
    internal init(environment: Environment, sessionToken: SessionToken, channelId: String) {
        self.environment = environment
        self.sessionToken = sessionToken
        self.channelId = channelId
        self.provider = ExposureProgramProvider()
        self.queue = DispatchQueue(label: "com.emp.exposure.programService",
                                   qos: DispatchQoS.background,
                                   attributes: DispatchQueue.Attributes.concurrent)
    }
    
    deinit {
        timer?.setEventHandler{}
        timer?.cancel()
    }
    
    internal var provider: ProgramProvider
    internal struct ExposureProgramProvider: ProgramProvider {
        func fetchProgram(on channelId: String, timestamp: Int64, using environment: Environment, callback: @escaping (Program?, ExposureError?) -> Void) {
            FetchEpg(environment: environment)
                .channel(id: channelId)
                .filter(starting: timestamp, ending: timestamp)
                .filter(onlyPublished: true)
                .request()
                .response{ callback($0.value?.programs?.first, $0.error) }
        }
        
        func validate(entitlementFor assetId: String, environment: Environment, sessionToken: SessionToken, callback: @escaping (EntitlementValidation?, ExposureError?) -> Void) {
            Entitlement(environment: environment, sessionToken: sessionToken)
                .validate(assetId: assetId)
                .request()
                .response{ callback($0.value, $0.error) }
        }
    }
}

extension ProgramService {
    fileprivate func validate(timestamp: Int64, callback: @escaping (String?) -> Void) {
        if let current = activeProgram, let start = current.startDate?.millisecondsSince1970, let end = current.endDate?.millisecondsSince1970 {
            if timestamp > start && timestamp < end {
                callback(nil)
                return
            }
        }
        
        // We do not have a current program or the timestamp in question is outside the program bounds
        provider.fetchProgram(on: channelId, timestamp: timestamp, using: environment) { [weak self] newProgram, error in
            guard let `self` = self else { return }
            if let program = newProgram, let assetId = program.assetId {
                self.activeProgram = program
                self.onProgramChanged(program)
                
                self.provider.validate(entitlementFor: assetId, environment: self.environment, sessionToken: self.sessionToken) { validation, error in
                    // TODO: What about errors? Should we be permissive or restrictive with errors on validation?
                    guard let expirationReason = validation?.status else {
                        callback(nil)
                        return
                    }
                    
                    guard expirationReason == "SUCCESS" else {
                        callback(expirationReason)
                        return
                    }
                    
                    callback(nil)
                }
            }
            else {
                callback(nil)
            }
        }
    }
}

extension ProgramService {
    fileprivate func stopTimer() {
        timer?.setEventHandler{}
        timer?.cancel()
    }
    
    internal func startMonitoring() {
        stopTimer()
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.scheduleRepeating(deadline: .now(), interval: .milliseconds(refreshInterval))
        
    }
//    internal func isEntitled(toPlay timestamp: Int64, callback: ())
}

extension ProgramService {
    internal var currentProgram: Program? {
        return activeProgram
    }

    internal func currentProgram(for timestamp: Int64, callback: @escaping (Program?, ExposureError?) -> Void) {
        provider.fetchProgram(on: channelId, timestamp: timestamp, using: environment, callback: callback)
    }
}
