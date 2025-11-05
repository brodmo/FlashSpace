//
//  AppDelegate.swift
//
//  Created by Wojciech Kulik on 13/02/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Start as accessory app (no Dock icon)
        NSApp.setActivationPolicy(.accessory)
        AppDependencies.shared.hotKeysManager.enableAll()
    }
}
