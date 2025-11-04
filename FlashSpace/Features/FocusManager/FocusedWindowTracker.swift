//
//  FocusedWindowTracker.swift
//
//  Created by Wojciech Kulik on 20/01/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

import AppKit
import Combine

final class FocusedWindowTracker {
    private var cancellables = Set<AnyCancellable>()

    private let workspaceRepository: WorkspaceRepository
    private let workspaceManager: WorkspaceManager
    private let settingsRepository: SettingsRepository

    init(
        workspaceRepository: WorkspaceRepository,
        workspaceManager: WorkspaceManager,
        settingsRepository: SettingsRepository
    ) {
        self.workspaceRepository = workspaceRepository
        self.workspaceManager = workspaceManager
        self.settingsRepository = settingsRepository

        activateWorkspaceForFocusedApp(force: true)
    }

    func startTracking() {
        NSWorkspace.shared.notificationCenter
            .publisher(for: NSWorkspace.didActivateApplicationNotification)
            .compactMap { $0.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication }
            .filter { $0.activationPolicy == .regular }
            .removeDuplicates()
            .sink { [weak self] app in self?.activeApplicationChanged(app, force: false) }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: .profileChanged)
            .sink { [weak self] _ in self?.activateWorkspaceForFocusedApp() }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: NSApplication.didChangeScreenParametersNotification)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in self?.activateWorkspaceForFocusedApp(force: true) }
            .store(in: &cancellables)
    }

    func stopTracking() {
        cancellables.removeAll()
    }

    private func activateWorkspaceForFocusedApp(force: Bool = false) {
        DispatchQueue.main.async {
            guard let activeApp = NSWorkspace.shared.frontmostApplication else { return }

            self.activeApplicationChanged(activeApp, force: force)
        }
    }

    private func activeApplicationChanged(_ app: NSRunningApplication, force: Bool) {
        guard force || settingsRepository.workspaceSettings.activeWorkspaceOnFocusChange else { return }

        let activeWorkspaces = workspaceManager.activeWorkspace.values

        // Skip if the workspace was activated recently
        guard Date().timeIntervalSince(workspaceManager.lastWorkspaceActivation) > 0.2 else { return }

        // Find the workspace that contains the app.
        // The same app can be in multiple workspaces, the highest priority has the one
        // from the active workspace.
        guard let workspace = (activeWorkspaces + workspaceRepository.workspaces)
            .first(where: { $0.apps.containsApp(app) }) else { return }

        // Skip if the workspace is already active
        guard activeWorkspaces.count(where: { $0.id == workspace.id }) < workspace.displays.count else { return }

        let activate = { [self] in
            Logger.log("")
            Logger.log("")
            Logger.log("Activating workspace for app: \(workspace.name)")
            workspaceManager.updateLastFocusedApp(app.toMacApp, in: workspace)
            workspaceManager.activateWorkspace(workspace, setFocus: false)
            app.activate()
        }

        if workspace.isDynamic, workspace.displays.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                activate()
            }
        } else {
            activate()
        }
    }
}
