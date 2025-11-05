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

        // NOTE: This tracker is currently disabled in the stateless architecture.
        // Auto-activation of workspaces based on focused apps goes against
        // the stateless design goal. Kept as no-op for potential future use.
    }

    func startTracking() {
        // No-op: disabled in stateless architecture
    }

    func stopTracking() {
        cancellables.removeAll()
    }
}
