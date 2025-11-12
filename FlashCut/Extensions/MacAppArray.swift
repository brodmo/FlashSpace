import AppKit

extension [MacApp] {
    func firstIndex(ofAppWith bundleIdentifier: BundleId) -> Int? {
        firstIndex { $0.bundleIdentifier == bundleIdentifier }
    }

    func firstIndex(of app: NSRunningApplication) -> Int? {
        firstIndex { $0.bundleIdentifier == app.bundleIdentifier }
    }

    func containsApp(with bundleIdentifier: BundleId?) -> Bool {
        contains { $0.bundleIdentifier == bundleIdentifier }
    }

    func containsApp(_ app: NSRunningApplication) -> Bool {
        contains { $0.bundleIdentifier == app.bundleIdentifier }
    }
}
