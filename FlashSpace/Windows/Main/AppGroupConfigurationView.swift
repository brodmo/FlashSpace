//
//  AppGroupConfigurationView.swift
//
//  Created by Wojciech Kulik on 20/02/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

import SwiftUI

struct AppGroupConfigurationView: View {
    @Environment(\.openWindow) var openWindow

    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        if viewModel.selectedAppGroup != nil {
            VStack(alignment: .leading, spacing: 0.0) {
                configuration

                if viewModel.appGroups.contains(where: { $0.apps.contains(where: \.bundleIdentifier.isEmpty) }) {
                    Text("Could not migrate some apps. Please re-add them to fix the problem.")
                        .foregroundColor(.errorRed)
                }

                Spacer()
                settingsButton
            }
        } else {
            VStack {
                Spacer()
                settingsButton
            }
        }
    }

    private var configuration: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            // Name and Shortcut on one line
            HStack {
                TextField("Name", text: $viewModel.appGroupName)
                    .onSubmit(viewModel.saveAppGroup)
                    .frame(maxWidth: .infinity)

                HotKeyControl(shortcut: $viewModel.appGroupShortcut)
                    .fixedSize()
            }
            .padding(.bottom, 8)

            // Primary App with tooltip
            HStack {
                Picker("Primary App", selection: $viewModel.appGroupTargetApp) {
                    ForEach(viewModel.targetAppOptions, id: \.self) {
                        Text($0.name.padEnd(toLength: 20)).tag($0)
                    }
                }
                .labelsHidden()

                Button(action: {}) {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .help("The primary app is always focused and launched if not running when activating this group")
            }
        }
    }

    private var settingsButton: some View {
        HStack {
            Button(action: {
                openWindow(id: "settings")
            }, label: {
                Image(systemName: "gearshape")
                    .foregroundColor(.primary)
            }).keyboardShortcut(",")
        }.frame(maxWidth: .infinity, alignment: .trailing)
    }
}
