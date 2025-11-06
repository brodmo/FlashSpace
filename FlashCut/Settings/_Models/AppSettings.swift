//
//  AppSettings.swift
//
//  Created by Wojciech Kulik on 15/02/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

struct AppSettings: Codable {
    enum CodingKeys: String, CodingKey {
        case checkForUpdatesAutomatically
        case showFlashCut
        case switchToNextAppInGroup = "focusNextAppGroupApp"
        case switchToPreviousAppInGroup = "focusPreviousAppGroupApp"
        case loopAppGroups
        case switchToRecentAppGroup
        case switchToPreviousAppGroup
        case switchToNextAppGroup
    }

    // General
    var checkForUpdatesAutomatically: Bool?
    var showFlashCut: AppHotKey?

    // App Manager
    var switchToNextAppInGroup: AppHotKey?
    var switchToPreviousAppInGroup: AppHotKey?

    // App Groups
    var loopAppGroups: Bool?
    var switchToRecentAppGroup: AppHotKey?
    var switchToPreviousAppGroup: AppHotKey?
    var switchToNextAppGroup: AppHotKey?
}
