import Foundation

extension URL {
    var bundle: Bundle? { Bundle(url: self) }
    var fileName: String { lastPathComponent.replacingOccurrences(of: ".app", with: "") }
    var appName: String { bundle?.localizedAppName ?? fileName }
    var bundleIdentifier: BundleId? { bundle?.bundleIdentifier }
    var iconPath: String? { bundle?.iconPath }

    func createIntermediateDirectories() throws {
        try FileManager.default.createDirectory(
            at: deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
    }
}
