//
//  FlashSpaceApp.swift
//  FlashCut
//
//  Created by Wojciech Kulik on 19/01/2025.
//

import Combine
import SwiftUI

@main
struct FlashCutApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @AppStorage("firstLaunch") private var firstLaunch = true

    @State private var cancellables = Set<AnyCancellable>()

    var body: some Scene {
        Window("⚡ FlashCut v\(AppConstants.version)", id: "main") {
            MainView()
                .onAppear {
                    setupWindowHandling()
                    handleFirstLaunch()
                }
        }
        .windowResizability(.contentSize)

        Window("Settings", id: "settings") {
            SettingsView()
        }
        .windowResizability(.contentSize)
    }

    private func setupWindowHandling() {
        NotificationCenter.default
            .publisher(for: .openMainWindow)
            .sink { _ in
                openWindow(id: "main")
                NSApp.activate(ignoringOtherApps: true)
            }
            .store(in: &cancellables)
    }

    private func handleFirstLaunch() {
        if firstLaunch {
            firstLaunch = false
        } else {
            dismissWindow(id: "main")
        }
    }
}
