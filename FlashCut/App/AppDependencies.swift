//
//  AppDependencies.swift
//
//  Created by Wojciech Kulik on 19/01/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

import ShortcutRecorder

struct AppDependencies {
    static let shared = AppDependencies()

    let appGroupRepository: AppGroupRepository
    let appGroupManager: AppGroupManager
    let appGroupHotKeys: AppGroupHotKeys

    let hotKeysMonitor: HotKeysMonitorProtocol = GlobalShortcutMonitor.shared
    let hotKeysManager: HotKeysManager

    let appManager: AppManager

    let settingsRepository: SettingsRepository
    let generalSettings = GeneralSettings()
    let appManagerSettings = AppManagerSettings()
    let appGroupSettings = AppGroupSettings()

    let autostartService = AutostartService()

    private init() {
        self.settingsRepository = SettingsRepository(
            generalSettings: generalSettings,
            appManagerSettings: appManagerSettings,
            appGroupSettings: appGroupSettings
        )
        self.appGroupRepository = AppGroupRepository()
        self.appGroupManager = AppGroupManager(
            appGroupRepository: appGroupRepository,
            settingsRepository: settingsRepository
        )
        self.appGroupHotKeys = AppGroupHotKeys(
            appGroupManager: appGroupManager,
            appGroupRepository: appGroupRepository,
            settingsRepository: settingsRepository
        )
        self.appManager = AppManager(
            appGroupRepository: appGroupRepository,
            appGroupManager: appGroupManager,
            appManagerSettings: appManagerSettings
        )
        self.hotKeysManager = HotKeysManager(
            hotKeysMonitor: GlobalShortcutMonitor.shared,
            appGroupHotKeys: appGroupHotKeys,
            appManager: appManager,
            settingsRepository: settingsRepository
        )
    }
}
