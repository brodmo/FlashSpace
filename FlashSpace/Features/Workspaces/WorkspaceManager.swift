//
//  WorkspaceManager.swift
//
//  Created by Wojciech Kulik on 19/01/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

import AppKit
import Combine

typealias DisplayName = String

struct ActiveWorkspace {
    let id: WorkspaceID
    let name: String
    let number: String?
    let symbolIconName: String?
    let display: DisplayName
}

final class WorkspaceManager: ObservableObject {
    @Published private(set) var activeWorkspaceDetails: ActiveWorkspace?

    private(set) var lastFocusedApp: [WorkspaceID: MacApp] = [:]
    private(set) var activeWorkspace: [DisplayName: Workspace] = [:]
    private(set) var mostRecentWorkspace: [DisplayName: Workspace] = [:]
    private(set) var lastWorkspaceActivation = Date.distantPast

    private var cancellables = Set<AnyCancellable>()
    private var observeFocusCancellable: AnyCancellable?

    private lazy var focusedWindowTracker = AppDependencies.shared.focusedWindowTracker

    private let workspaceRepository: WorkspaceRepository
    private let workspaceSettings: WorkspaceSettings
    private let displayManager: DisplayManager

    init(
        workspaceRepository: WorkspaceRepository,
        settingsRepository: SettingsRepository,
        displayManager: DisplayManager
    ) {
        self.workspaceRepository = workspaceRepository
        self.workspaceSettings = settingsRepository.workspaceSettings
        self.displayManager = displayManager

        PermissionsManager.shared.askForAccessibilityPermissions()
        observe()
    }

    private func observe() {
        NotificationCenter.default
            .publisher(for: NSApplication.didChangeScreenParametersNotification)
            .sink { [weak self] _ in
                self?.activeWorkspace = [:]
                self?.mostRecentWorkspace = [:]
                self?.activeWorkspaceDetails = nil
            }
            .store(in: &cancellables)

        workspaceRepository.workspacesPublisher
            .sink { [weak self] workspaces in
                self?.updateWorkspaces(workspaces)
            }
            .store(in: &cancellables)

        observeFocus()
    }

    private func observeFocus() {
        observeFocusCancellable = NSWorkspace.shared.notificationCenter
            .publisher(for: NSWorkspace.didActivateApplicationNotification)
            .compactMap { $0.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication }
            .filter { $0.activationPolicy == .regular }
            .sink { [weak self] application in
                self?.rememberLastFocusedApp(application, retry: true)
            }
    }

    private func rememberLastFocusedApp(_ application: NSRunningApplication, retry: Bool) {
        guard application.display != nil else {
            if retry {
                Logger.log("Retrying to get display for \(application.localizedName ?? "")")
                return DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    if let frontmostApp = NSWorkspace.shared.frontmostApplication {
                        self.rememberLastFocusedApp(frontmostApp, retry: false)
                    }
                }
            } else {
                return Logger.log("Unable to get display for \(application.localizedName ?? "")")
            }
        }

        let focusedDisplay = NSScreen.main?.localizedName ?? ""

        if let activeWorkspace = activeWorkspace[focusedDisplay], activeWorkspace.apps.containsApp(application) {
            updateLastFocusedApp(application.toMacApp, in: activeWorkspace)
            updateActiveWorkspace(activeWorkspace, on: [focusedDisplay])
        }

        displayManager.trackDisplayFocus(on: focusedDisplay, for: application)
    }

    private func updateWorkspaces(_ workspaces: [Workspace]) {
        let updatedWorkspaces = workspaces.reduce(into: [WorkspaceID: Workspace]()) { $0[$1.id] = $1 }

        for (display, workspace) in activeWorkspace {
            activeWorkspace[display] = updatedWorkspaces[workspace.id]
        }

        for (display, workspace) in mostRecentWorkspace {
            mostRecentWorkspace[display] = updatedWorkspaces[workspace.id]
        }
    }

    private func findAppToFocus(in workspace: Workspace) -> NSRunningApplication? {
        let runningApps = NSWorkspace.shared.runningApplications
            .filter { workspace.apps.containsApp($0) }

        var appToFocus: NSRunningApplication?

        if workspace.appToFocus == nil {
            appToFocus = runningApps.find(lastFocusedApp[workspace.id])
        } else {
            appToFocus = runningApps.find(workspace.appToFocus)
        }

        let fallbackToLastApp = runningApps.findFirstMatch(with: workspace.apps.reversed())
        let fallbackToFinder = NSWorkspace.shared.runningApplications.first(where: \.isFinder)

        return appToFocus ?? fallbackToLastApp ?? fallbackToFinder
    }

    private func centerCursorIfNeeded(in frame: CGRect?) {
        guard workspaceSettings.centerCursorOnWorkspaceChange, let frame else { return }

        CGWarpMouseCursorPosition(CGPoint(x: frame.midX, y: frame.midY))
    }

    private func updateActiveWorkspace(_ workspace: Workspace, on displays: Set<DisplayName>) {
        lastWorkspaceActivation = Date()

        // Save the most recent workspace if it's not the current one
        for display in displays {
            if activeWorkspace[display]?.id != workspace.id {
                mostRecentWorkspace[display] = activeWorkspace[display]
            }
            activeWorkspace[display] = workspace
        }

        activeWorkspaceDetails = .init(
            id: workspace.id,
            name: workspace.name,
            number: workspaceRepository.workspaces
                .firstIndex { $0.id == workspace.id }
                .map { "\($0 + 1)" },
            symbolIconName: workspace.symbolIconName,
            display: workspace.displayForPrint
        )
    }

    private func openAppsIfNeeded(in workspace: Workspace) {
        guard workspace.openAppsOnActivation == true else { return }

        let runningBundleIds = NSWorkspace.shared.runningApplications
            .compactMap(\.bundleIdentifier)
            .asSet

        workspace.apps
            .filter { !runningBundleIds.contains($0.bundleIdentifier) }
            .compactMap { NSWorkspace.shared.urlForApplication(withBundleIdentifier: $0.bundleIdentifier) }
            .forEach { appUrl in
                Logger.log("Open App: \(appUrl)")

                let config = NSWorkspace.OpenConfiguration()
                NSWorkspace.shared.openApplication(at: appUrl, configuration: config) { _, error in
                    if let error {
                        Logger.log("Failed to open \(appUrl): \(error.localizedDescription)")
                    }
                }
            }
    }
}

// MARK: - Workspace Actions
extension WorkspaceManager {
    func activateWorkspace(_ workspace: Workspace, setFocus: Bool) {
        let displays = workspace.displays

        Logger.log("")
        Logger.log("")
        Logger.log("APP GROUP: \(workspace.name)")
        Logger.log("DISPLAYS: \(displays.joined(separator: ", "))")
        Logger.log("----")

        // If dynamic workspace with no running apps, optionally launch them
        if workspace.isDynamic, workspace.displays.isEmpty,
           workspace.apps.isNotEmpty, workspace.openAppsOnActivation == true {
            Logger.log("No running apps in the group - launching apps")
            openAppsIfNeeded(in: workspace)

            if !workspaceSettings.activeWorkspaceOnFocusChange {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.activateWorkspace(workspace, setFocus: setFocus)
                }
            }
            return
        }

        guard displays.isNotEmpty else {
            Logger.log("No displays found for workspace: \(workspace.name) - skipping")
            return
        }

        focusedWindowTracker.stopTracking()
        defer { focusedWindowTracker.startTracking() }

        updateActiveWorkspace(workspace, on: displays)
        openAppsIfNeeded(in: workspace)

        // Simply focus an app in the group if requested
        if setFocus {
            let toFocus = findAppToFocus(in: workspace)
            Logger.log("FOCUS: \(toFocus?.localizedName ?? "none")")
            toFocus?.activate()
            centerCursorIfNeeded(in: toFocus?.frame)
        }
    }

    func assignApps(_ apps: [MacApp], to workspace: Workspace) {
        for app in apps {
            workspaceRepository.deleteAppFromAllWorkspaces(app: app)
            workspaceRepository.addApp(to: workspace.id, app: app)
        }

        NotificationCenter.default.post(name: .appsListChanged, object: nil)
    }

    func assignApp(_ app: MacApp, to workspace: Workspace) {
        workspaceRepository.deleteAppFromAllWorkspaces(app: app)
        workspaceRepository.addApp(to: workspace.id, app: app)

        guard let targetWorkspace = workspaceRepository.findWorkspace(with: workspace.id) else { return }

        updateLastFocusedApp(app, in: targetWorkspace)

        if workspaceSettings.changeWorkspaceOnAppAssign {
            activateWorkspace(targetWorkspace, setFocus: true)
        } else {
            AppDependencies.shared.focusManager.nextWorkspaceApp()
        }

        NotificationCenter.default.post(name: .appsListChanged, object: nil)
    }

    func activateWorkspace(next: Bool, skipEmpty: Bool, loop: Bool) {
        let screen = workspaceSettings.switchWorkspaceOnCursorScreen
            ? displayManager.getCursorScreen()
            : NSScreen.main?.localizedName

        guard let screen else { return }

        var workspacesToLoop = workspaceRepository.workspaces

        if !workspaceSettings.loopWorkspacesOnAllDisplays {
            workspacesToLoop = workspacesToLoop
                .filter { $0.displays.contains(screen) }
        }

        if !next {
            workspacesToLoop = workspacesToLoop.reversed()
        }

        guard let activeWorkspace = activeWorkspace[screen] ?? workspacesToLoop.first else { return }

        let nextWorkspaces = workspacesToLoop
            .drop(while: { $0.id != activeWorkspace.id })
            .dropFirst()

        var selectedWorkspace = nextWorkspaces.first ?? (loop ? workspacesToLoop.first : nil)

        if skipEmpty {
            let runningApps = NSWorkspace.shared.runningRegularApps
                .compactMap(\.bundleIdentifier)
                .asSet

            selectedWorkspace = (nextWorkspaces + (loop ? workspacesToLoop : []))
                .drop(while: { $0.apps.allSatisfy { !runningApps.contains($0.bundleIdentifier) } })
                .first
        }

        guard let selectedWorkspace, selectedWorkspace.id != activeWorkspace.id else { return }

        activateWorkspace(selectedWorkspace, setFocus: true)
    }

    func activateRecentWorkspace() {
        guard let screen = displayManager.getCursorScreen(),
              let mostRecentWorkspace = mostRecentWorkspace[screen]
        else { return }

        activateWorkspace(mostRecentWorkspace, setFocus: true)
    }

    func activateWorkspaceIfActive(_ workspaceId: WorkspaceID) {
        guard activeWorkspace.values.contains(where: { $0.id == workspaceId }) else { return }
        guard let updatedWorkspace = workspaceRepository.findWorkspace(with: workspaceId) else { return }

        activateWorkspace(updatedWorkspace, setFocus: false)
    }

    func updateLastFocusedApp(_ app: MacApp, in workspace: Workspace) {
        lastFocusedApp[workspace.id] = app
    }
}
