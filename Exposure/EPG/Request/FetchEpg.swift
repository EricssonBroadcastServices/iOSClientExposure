//
//  FetchEpg.swift
//  Exposure
//
//  Created by Fredrik Sjöberg on 2017-06-14.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

public struct FetchEpg {
    public let environment: Environment
    
    public init(environment: Environment) {
        self.environment = environment
    }
}

extension FetchEpg {
    public func channels() -> FetchEpgChannelList {
        return FetchEpgChannelList(environment: environment)
    }
    
    public func channel(id: String) -> FetchEpgChannel {
        return FetchEpgChannel(environment: environment, channelId: id)
    }
    
    public func channels(ids: [String]) -> FetchEpgChannelList {
        return FetchEpgChannelList(environment: environment)
            .filter(onlyAssetIds: ids)
    }
    
    public func channel(id: String, programId: String) -> FetchEpgProgram {
        return FetchEpgProgram(environment: environment,
                               channelId: id,
                               programId: programId)
    }
}
