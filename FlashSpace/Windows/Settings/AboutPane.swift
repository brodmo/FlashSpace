//
//  AboutPane.swift
//
//  Created by Wojciech Kulik on 18/02/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

import SwiftUI

struct AboutPane: View {
    var body: some View {
        Form {
            Section("FlashCut") {
                HStack {
                    Text("Version \(AppConstants.version)")
                    Spacer()
                    Button("GitHub") { openGitHub("brodmo/FlashSpace") }
                    Button("Check for Updates") { UpdatesManager.shared.checkForUpdates() }
                }
                Text("FlashCut is a lightweight, keyboard-focused fork of FlashSpace")
                    .foregroundStyle(.secondary)
                    .font(.callout)
            }

            Section("Author") {
                HStack {
                    Text("Moritz Brödel (@brodmo)")
                    Spacer()
                    Button("GitHub") { openGitHub("brodmo") }
                }
            }

            Section("Based On") {
                HStack {
                    Text("FlashSpace by Wojciech Kulik")
                    Spacer()
                    Button("GitHub") { openGitHub("wojciech-kulik/FlashSpace") }
                }
            }
        }
        .buttonStyle(.accessoryBarAction)
        .formStyle(.grouped)
        .navigationTitle("About")
    }

    private func openGitHub(_ login: String) {
        openUrl("https://github.com/\(login)")
    }

    private func openUrl(_ url: String) {
        if let url = URL(string: url) {
            NSWorkspace.shared.open(url)
        }
    }
}
