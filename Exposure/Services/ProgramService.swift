//
//  ProgramService.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-01-10.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation

internal protocol ProgramProvider {
    func fetchProgram(programId: String, channelId: String, using environment: Environment, callback: @escaping (Program?, ExposureError?) -> Void)
}

internal class ProgramService {
    /// `Environment` to use when requesting program data
    fileprivate var environment: Environment
    
    internal init(environment: Environment) {
        self.environment = environment
        self.provider = ExposureProgramProvider()
    }
    
    internal var provider: ProgramProvider
    internal struct ExposureProgramProvider: ProgramProvider {
        func fetchProgram(programId: String, channelId: String, using environment: Environment, callback: @escaping (Program?, ExposureError?) -> Void) {
            FetchEpg(environment: environment)
                .channel(id: channelId, programId: programId)
                .request()
                .response{
                    callback($0.value, $0.error)
            }
        }
    }
}

extension ProgramService {
    internal var currentProgram: Program? {
        
    }

    internal func currentProgram(callback: @escaping (Program?, ExposureError?) -> Void) {
        
    }
}
