//
//  BackgroundAnalyticsManager.swift
//  
//
//  Created by Udaya Sri Senarathne on 2023-09-20.
//

import Foundation
import UIKit
import SystemConfiguration



/// Handles analytics related to System Background Triggers.
public class BackgroundAnalyticsManager {
    
    public init() {}

    /// Pass notification `didRefreshedInBackgroundNotification`
    public func flushOfflineAnalytics() {
        let notificationName = "didRefreshedInBackgroundNotification"
        NotificationCenter.default.post(name:  NSNotification.Name(rawValue:notificationName), object: nil)
    }

}
