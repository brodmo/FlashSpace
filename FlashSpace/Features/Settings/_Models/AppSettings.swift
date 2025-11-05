//
//  AppSettings.swift
//
//  Created by Wojciech Kulik on 15/02/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

struct AppSettings: Codable {
    // General
    var checkForUpdatesAutomatically: Bool?
    var showFlashSpace: AppHotKey?
    var showFloatingNotifications: Bool?

    // Menu Bar
    var showMenuBarTitle: Bool?
    var showMenuBarIcon: Bool?
    var menuBarTitleTemplate: String?
    var menuBarDisplayAliases: String?

    // Focus Manager
    var enableFocusManagement: Bool?
    var centerCursorOnFocusChange: Bool?
    var focusNextWorkspaceApp: AppHotKey?
    var focusPreviousWorkspaceApp: AppHotKey?
    var focusNextWorkspaceWindow: AppHotKey?
    var focusPreviousWorkspaceWindow: AppHotKey?
    var focusFrontmostWindow: Bool?

    // Workspaces
    var displayMode: DisplayMode?
    var centerCursorOnWorkspaceChange: Bool?
    var changeWorkspaceOnAppAssign: Bool?
    var activeWorkspaceOnFocusChange: Bool?
    var skipEmptyWorkspacesOnSwitch: Bool?
    var keepUnassignedAppsOnSwitch: Bool?
    var restoreHiddenAppsOnSwitch: Bool?

    var loopWorkspaces: Bool?
    var loopWorkspacesOnAllDisplays: Bool?
    var switchWorkspaceOnCursorScreen: Bool?
    var switchToPreviousWorkspace: AppHotKey?
    var switchToNextWorkspace: AppHotKey?
    var switchToRecentWorkspace: AppHotKey?
    var assignFocusedApp: AppHotKey?
    var unassignFocusedApp: AppHotKey?
    var toggleFocusedAppAssignment: AppHotKey?
    var assignVisibleApps: AppHotKey?
    var alternativeDisplays: String?
}
