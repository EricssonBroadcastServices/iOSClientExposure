//
//  HLSNative+ExposureContext+Program.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2018-01-10.
//  Copyright © 2018 emp. All rights reserved.
//

import Foundation
import Player

// MARK: - Program Data
extension Player where Tech == HLSNative<ExposureContext> {
    public var currentProgram: Program? {
        return context.programService.currentProgram
    }
    
    public func currentProgram(callback: @escaping (Program?, ExposureError?) -> Void) {
        context.programService.currentProgram(callback: callback)
    }
    
    public func fetch(programId: String, channelId: String, callback: @escaping (Program?, ExposureError?) -> Void) {
        context
            .programService
            .provider
            .fetchProgram(programId: programId,
                          channelId: channelId,
                          using: context.environment) { callback($0,$1) }
    }
}
