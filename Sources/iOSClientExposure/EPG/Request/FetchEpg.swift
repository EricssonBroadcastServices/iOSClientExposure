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
    private let version: Version
    private let date: Date
    
    @available(
        *, deprecated,
         message: "This constructor still uses old v1 default endpoint. Please use FetchEpg contructor with explicit v2 Environment version."
    )
    public init(environment: Environment) {
        self.version = .v1
        self.date = Date()
        self.environment = environment
    }
    
    public init(
        environment: Environment,
        date: Date = Date(),
        version: Version
    ) {
        var env = environment
        env.version = version.rawValue
        self.date = date
        self.version = version
        self.environment = env
    }
}

extension FetchEpg {
    /// Fetches EPG data for **all** channels.
    ///
    /// - returns: `FetchEpgChannelList` struct used to process the request.
    public func channels() -> FetchEpgChannelList {
        return FetchEpgChannelList(
            environment: environment,
            date: date,
            version: version
        )
    }
    
    /// Fetches EPG data for a specific channel.
    ///
    /// - parameter id: channel to requested
    /// - returns: `FetchEpgChannel` struct used to process the request.
    public func channel(id: String) -> FetchEpgChannel {
        return FetchEpgChannel(
            environment: environment,
            channelId: id,
            date: date,
            version: version
        )
    }
    
    /// Fetches EPG data for a set of channels.
    ///
    /// - parameter ids: array of channelIds to request
    /// - returns: `FetchEpgChannelList` struct used to process the request.
    public func channels(ids: [String]) -> FetchEpgChannelList {
        return FetchEpgChannelList(
            environment: environment,
            date: date,
            version: version
        )
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
    
    public func next(programId: String) -> FetchNextProgram {
        return FetchNextProgram(environment: environment,
                                programId: programId)
    }
    
    public func previous(programId: String) -> FetchPreviousProgram {
        return FetchPreviousProgram(environment: environment,
                                    programId: programId)
    }
}

//MARK: - FetchEpg Endpoint Version

public extension FetchEpg {
    enum Version: String {
        case v1
        case v2
    }
}
