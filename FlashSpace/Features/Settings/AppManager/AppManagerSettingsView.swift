//
//  AppManagerSettingsView.swift
//
//  Created by Wojciech Kulik on 23/01/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

import SwiftUI

struct AppManagerSettingsView: View {
    @StateObject private var settings = AppDependencies.shared.appManagerSettings

    var body: some View {
        Form {
            Section("App Switching") {
                hotkey("Switch to Next App in Group", for: $settings.switchToNextAppInGroup)
                hotkey("Switch to Previous App in Group", for: $settings.switchToPreviousAppInGroup)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("App Manager")
    }
}
