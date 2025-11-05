//
//  WorkspacesSettingsView.swift
//
//  Created by Wojciech Kulik on 24/01/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

import SwiftUI

struct WorkspacesSettingsView: View {
    @StateObject var settings = AppDependencies.shared.workspaceSettings

    var body: some View {
        Form {
            Section("Displays") {
                Picker("Display Assignment Mode", selection: $settings.displayMode) {
                    ForEach(DisplayMode.allCases) { action in
                        Text(action.description).tag(action)
                    }
                }

                Text("Static Mode requires you to manually assign workspaces to displays.\n\n" +
                    "Dynamic Mode automatically assigns workspaces to displays " +
                    "based on where your applications are located. In this mode, a single workspace can span across multiple displays."
                )
                .font(.callout)
                .foregroundStyle(.secondary)
            }

            Section("Behaviors") {
                Toggle("Activate Workspace On Focus Change", isOn: $settings.activeWorkspaceOnFocusChange)
                Toggle("Center Cursor In Focused App On Workspace Change", isOn: $settings.centerCursorOnWorkspaceChange)
                Toggle("Automatically Change Workspace On App Assignment", isOn: $settings.changeWorkspaceOnAppAssign)
                Toggle("Keep Unassigned Apps On Workspace Change", isOn: $settings.keepUnassignedAppsOnSwitch)
                Toggle("Show Hidden Apps On Workspace Activation", isOn: $settings.restoreHiddenAppsOnSwitch)
                    .help("Restores hidden apps, even if they were hidden manually")
            }

            Section("Shortcuts") {
                hotkey("Assign Visible Apps (to active workspace)", for: $settings.assignVisibleApps)
                hotkey("Assign Focused App (to active workspace)", for: $settings.assignFocusedApp)
                hotkey("Unassign Focused App", for: $settings.unassignFocusedApp)
                hotkey("Toggle Focused App Assignment", for: $settings.toggleFocusedAppAssignment)
            }

            Section {
                hotkey("Recent Workspace", for: $settings.switchToRecentWorkspace)
                hotkey("Previous Workspace", for: $settings.switchToPreviousWorkspace)
                hotkey("Next Workspace", for: $settings.switchToNextWorkspace)
                Toggle("Loop Workspaces", isOn: $settings.loopWorkspaces)
                Toggle("Loop On All Displays", isOn: $settings.loopWorkspacesOnAllDisplays)
                Toggle("Start On Cursor Screen", isOn: $settings.switchWorkspaceOnCursorScreen)
                Toggle("Skip Empty Workspaces", isOn: $settings.skipEmptyWorkspacesOnSwitch)
                Text(
                    "These shortcuts allow you to cycle through workspaces on the display where the cursor is currently located."
                )
                .foregroundStyle(.secondary)
                .font(.callout)
            }

            Section {
                HStack {
                    Text("Alternative Displays")
                    TextField("", text: $settings.alternativeDisplays)
                        .foregroundColor(.secondary)
                        .standardPlaceholder(settings.alternativeDisplays.isEmpty)
                }

                Text(
                    """
                    Example: DELL XYZ=Benq ABC;LG 123=DELL XYZ

                    This setting is useful if you want to use the same configuration for different displays.
                    You can tell FlashCut which display should be used if the selected one is not connected.

                    If only one display is connected, it will always act as the fallback.
                    """
                )
                .foregroundStyle(.secondary)
                .font(.callout)
            }
            .hidden(settings.displayMode == .dynamic)
        }
        .formStyle(.grouped)
        .navigationTitle("Workspaces")
    }
}
