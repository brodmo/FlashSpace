//
//  MenuBarTitle.swift
//
//  Created by Wojciech Kulik on 31/01/2025.
//  Copyright © 2025 Wojciech Kulik. All rights reserved.
//

enum MenuBarTitle {
    static let settings = AppDependencies.shared.menuBarSettings

    static func get() -> String? {
        // Simplified for stateless architecture - just show "FlashCut"
        guard settings.showMenuBarTitle else { return nil }
        return "FlashCut"
    }
}
