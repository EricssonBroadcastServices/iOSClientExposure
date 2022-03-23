//
//  PersistedAnalytics.swift
//  Analytics
//
//  Created by Fredrik Sjöberg on 2017-08-01.
//  Copyright © 2017 emp. All rights reserved.
//

import Foundation

/// Defines an `AnalyticsBatch` decoded from previously *persisted* data.
internal struct PersistedAnalytics {
    /// `URL` to where `batch` is stored.
    let url: URL
    
    /// *Persisted* analytics data.
    let batch: AnalyticsBatch
}
