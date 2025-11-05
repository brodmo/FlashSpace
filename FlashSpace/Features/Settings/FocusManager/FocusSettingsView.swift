//
//  FocusSettingsView.swift
//
//  Created by Wojciech Kulik on 23/01/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

import SwiftUI

struct FocusSettingsView: View {
    @StateObject private var settings = AppDependencies.shared.focusManagerSettings

    var body: some View {
        Form {
            Section {
                Toggle("Enable Focus Manager", isOn: $settings.enableFocusManagement)
            }

            Group {
                Section("Trigger when focus is changed using shortcuts") {
                    Toggle("Center Cursor In Focused App", isOn: $settings.centerCursorOnFocusChange)
                }

                Section("App Cycling") {
                    hotkey("Focus Next App", for: $settings.focusNextAppGroupApp)
                    hotkey("Focus Previous App", for: $settings.focusPreviousAppGroupApp)
                }

                Section("Window Cycling") {
                    hotkey("Focus Next Window", for: $settings.focusNextAppGroupWindow)
                    hotkey("Focus Previous Window", for: $settings.focusPreviousAppGroupWindow)
                }
            }
            .disabled(!settings.enableFocusManagement)
            .opacity(settings.enableFocusManagement ? 1 : 0.5)
        }
        .formStyle(.grouped)
        .navigationTitle("Focus Manager")
    }
}
