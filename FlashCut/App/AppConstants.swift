import AppKit

enum AppConstants {
    static let lastFocusedOption = MacApp(
        name: "None",
        bundleIdentifier: "flashcut.last-focused",
        iconPath: nil
    )

    static var version: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "Unknown"
        }

        #if DEBUG
        return version + " (debug)"
        #else
        return version
        #endif
    }
}
