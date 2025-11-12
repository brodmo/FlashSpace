import AppKit

extension NSRunningApplication {
    var toMacApp: MacApp { .init(app: self) }
    var iconPath: String? { bundleURL?.iconPath }
}

extension [NSRunningApplication] {
    func find(_ app: MacApp?) -> NSRunningApplication? {
        guard let app else { return nil }

        return first { $0.bundleIdentifier == app.bundleIdentifier }
    }

    func findFirstMatch(with apps: [MacApp]) -> NSRunningApplication? {
        let bundleIdentifiers = apps.map(\.bundleIdentifier).asSet

        return first { bundleIdentifiers.contains($0.bundleIdentifier ?? "") }
    }
}
