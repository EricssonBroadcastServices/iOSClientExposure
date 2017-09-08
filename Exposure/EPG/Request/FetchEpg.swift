//
//  FetchEpg.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// *Exposure* request for fetching *EPG*.
public struct FetchEpg {
    /// `Environment` to use
    public let environment: Environment
    
    public init(environment: Environment) {
        self.environment = environment
    }
}

extension FetchEpg {
    /// Fetches EPG data for **all** channels.
    ///
    /// - returns: `FetchEpgChannelList` struct used to process the request.
    public func channels() -> FetchEpgChannelList {
        return FetchEpgChannelList(environment: environment)
    }
    
    /// Fetches EPG data for a specific channel.
    ///
    /// - parameter id: channel to requested
    /// - returns: `FetchEpgChannel` struct used to process the request.
    public func channel(id: String) -> FetchEpgChannel {
        return FetchEpgChannel(environment: environment, channelId: id)
    }
    
    /// Fetches EPG data for a set of channels.
    ///
    /// - parameter ids: array of channelIds to request
    /// - returns: `FetchEpgChannelList` struct used to process the request.
    public func channels(ids: [String]) -> FetchEpgChannelList {
        return FetchEpgChannelList(environment: environment)
            .filter(onlyAssetIds: ids)
    }
    
    /// Fetches programming data for a specific program on a specified channel.
    ///
    /// - parameter id: channelId for the requested channel
    /// - parameter programId: programId for the requested program
    /// - returns: `FetchEpgProgram` struct used to process the request.
    public func channel(id: String, programId: String) -> FetchEpgProgram {
        return FetchEpgProgram(environment: environment,
                               channelId: id,
                               programId: programId)
    }
    
    /// Fetches programming data for a specific program on a specified channel.
    ///
    /// - parameter programId: programId for the requested program
    /// - parameter channelId: channelId for the requested channel
    /// - returns: `FetchProgramAiring` struct used to process the request.
    public func airingFor(programId: String, channelId: String) -> FetchProgramAiring {
        return FetchProgramAiring(environment: environment,
                                  channelId: channelId,
                                  programId: programId)
    }
}
