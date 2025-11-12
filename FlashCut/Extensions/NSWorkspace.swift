import AppKit

extension NSWorkspace {
    var runningRegularApps: [NSRunningApplication] {
        runningApplications.filter { $0.activationPolicy == .regular }
    }
}
