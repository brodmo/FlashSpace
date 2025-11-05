//
//  WorkspaceSettings.swift
//
//  Created by Wojciech Kulik on 16/02/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

import Combine
import Foundation

final class WorkspaceSettings: ObservableObject {
    @Published var displayMode: DisplayMode = .static

    @Published var centerCursorOnWorkspaceChange = false
    @Published var changeWorkspaceOnAppAssign = true
    @Published var activeWorkspaceOnFocusChange = true
    @Published var skipEmptyWorkspacesOnSwitch = false
    @Published var keepUnassignedAppsOnSwitch = false
    @Published var restoreHiddenAppsOnSwitch = true

    @Published var assignFocusedApp: AppHotKey?
    @Published var unassignFocusedApp: AppHotKey?
    @Published var toggleFocusedAppAssignment: AppHotKey?
    @Published var assignVisibleApps: AppHotKey?

    @Published var loopWorkspaces = true
    @Published var loopWorkspacesOnAllDisplays = false
    @Published var switchWorkspaceOnCursorScreen = false
    @Published var switchToRecentWorkspace: AppHotKey?
    @Published var switchToPreviousWorkspace: AppHotKey?
    @Published var switchToNextWorkspace: AppHotKey?

    @Published var alternativeDisplays = ""

    private var observer: AnyCancellable?
    private let updateSubject = PassthroughSubject<(), Never>()

    init() { observe() }

    private func observe() {
        observer = Publishers.MergeMany(
            $displayMode.settingsPublisher(),

            $centerCursorOnWorkspaceChange.settingsPublisher(),
            $changeWorkspaceOnAppAssign.settingsPublisher(),
            $activeWorkspaceOnFocusChange.settingsPublisher(),
            $skipEmptyWorkspacesOnSwitch.settingsPublisher(),
            $keepUnassignedAppsOnSwitch.settingsPublisher(),
            $restoreHiddenAppsOnSwitch.settingsPublisher(),

            $assignFocusedApp.settingsPublisher(),
            $unassignFocusedApp.settingsPublisher(),
            $toggleFocusedAppAssignment.settingsPublisher(),
            $assignVisibleApps.settingsPublisher(),

            $loopWorkspaces.settingsPublisher(),
            $loopWorkspacesOnAllDisplays.settingsPublisher(),
            $switchWorkspaceOnCursorScreen.settingsPublisher(),
            $switchToRecentWorkspace.settingsPublisher(),
            $switchToPreviousWorkspace.settingsPublisher(),
            $switchToNextWorkspace.settingsPublisher(),

            $alternativeDisplays.settingsPublisher(debounce: true)
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] in self?.updateSubject.send() }
    }
}

extension WorkspaceSettings: SettingsProtocol {
    var updatePublisher: AnyPublisher<(), Never> {
        updateSubject.eraseToAnyPublisher()
    }

    func load(from appSettings: AppSettings) {
        observer = nil
        displayMode = appSettings.displayMode ?? .static

        centerCursorOnWorkspaceChange = appSettings.centerCursorOnWorkspaceChange ?? false
        changeWorkspaceOnAppAssign = appSettings.changeWorkspaceOnAppAssign ?? true
        activeWorkspaceOnFocusChange = appSettings.activeWorkspaceOnFocusChange ?? true
        skipEmptyWorkspacesOnSwitch = appSettings.skipEmptyWorkspacesOnSwitch ?? false
        keepUnassignedAppsOnSwitch = appSettings.keepUnassignedAppsOnSwitch ?? false
        restoreHiddenAppsOnSwitch = appSettings.restoreHiddenAppsOnSwitch ?? true

        assignFocusedApp = appSettings.assignFocusedApp
        unassignFocusedApp = appSettings.unassignFocusedApp
        toggleFocusedAppAssignment = appSettings.toggleFocusedAppAssignment
        assignVisibleApps = appSettings.assignVisibleApps

        loopWorkspaces = appSettings.loopWorkspaces ?? true
        loopWorkspacesOnAllDisplays = appSettings.loopWorkspacesOnAllDisplays ?? false
        switchWorkspaceOnCursorScreen = appSettings.switchWorkspaceOnCursorScreen ?? false
        switchToRecentWorkspace = appSettings.switchToRecentWorkspace
        switchToPreviousWorkspace = appSettings.switchToPreviousWorkspace
        switchToNextWorkspace = appSettings.switchToNextWorkspace

        alternativeDisplays = appSettings.alternativeDisplays ?? ""
        observe()
    }

    func update(_ appSettings: inout AppSettings) {
        appSettings.displayMode = displayMode

        appSettings.centerCursorOnWorkspaceChange = centerCursorOnWorkspaceChange
        appSettings.changeWorkspaceOnAppAssign = changeWorkspaceOnAppAssign
        appSettings.activeWorkspaceOnFocusChange = activeWorkspaceOnFocusChange
        appSettings.skipEmptyWorkspacesOnSwitch = skipEmptyWorkspacesOnSwitch
        appSettings.keepUnassignedAppsOnSwitch = keepUnassignedAppsOnSwitch
        appSettings.restoreHiddenAppsOnSwitch = restoreHiddenAppsOnSwitch

        appSettings.assignFocusedApp = assignFocusedApp
        appSettings.unassignFocusedApp = unassignFocusedApp
        appSettings.toggleFocusedAppAssignment = toggleFocusedAppAssignment
        appSettings.assignVisibleApps = assignVisibleApps

        appSettings.loopWorkspaces = loopWorkspaces
        appSettings.loopWorkspacesOnAllDisplays = loopWorkspacesOnAllDisplays
        appSettings.switchWorkspaceOnCursorScreen = switchWorkspaceOnCursorScreen
        appSettings.switchToRecentWorkspace = switchToRecentWorkspace
        appSettings.switchToPreviousWorkspace = switchToPreviousWorkspace
        appSettings.switchToNextWorkspace = switchToNextWorkspace

        appSettings.alternativeDisplays = alternativeDisplays
    }
}
