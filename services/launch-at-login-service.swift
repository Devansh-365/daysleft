import Foundation
import AppKit
import ServiceManagement

/// The parts of `SMAppService` the app uses, so tests can substitute a fake.
protocol LoginItemService {
    var status: SMAppService.Status { get }
    func register() throws
    func unregister() throws
}

extension SMAppService: LoginItemService {}

/// Launch-at-login state for the Settings window.
///
/// macOS (`SMAppService.status`) is the source of truth, never a stored preference,
/// so the toggle can't claim ON while nothing is registered.
///
/// The app never registers itself: launch at login changes only when the user flips the
/// switch in Settings, so macOS never shows a "Login item added" alert on its own.
///
/// Note: `register()` needs a signed `.app` bundle (ad-hoc is enough for local installs).
/// `scripts/create-dmg.sh` signs the bundle.
final class LaunchAtLoginModel: ObservableObject {
    static let shared = LaunchAtLoginModel()

    @Published private(set) var isEnabled: Bool
    /// macOS registered the app but the user must approve it in System Settings › Login Items.
    @Published private(set) var needsApproval: Bool
    /// Plain-language error from the last change attempt, if it failed.
    @Published private(set) var errorMessage: String?

    private let service: LoginItemService

    init(service: LoginItemService = SMAppService.mainApp) {
        self.service = service
        self.isEnabled = service.status == .enabled
        self.needsApproval = service.status == .requiresApproval
    }

    /// Re-read the real status (e.g. after the user changed it in System Settings).
    func refresh() {
        let status = service.status
        isEnabled = status == .enabled
        needsApproval = status == .requiresApproval
    }

    func setEnabled(_ enabled: Bool) {
        errorMessage = nil
        do {
            if enabled {
                try service.register()
            } else {
                try service.unregister()
            }
        } catch {
            errorMessage = enabled
                ? "Couldn't turn on launch at login. Move Days Left to Applications and try again."
                : "Couldn't turn off launch at login. You can remove it in System Settings › Login Items."
        }
        // Whatever happened, show what macOS actually has.
        refresh()
    }

    func openLoginItemsSettings() {
        SMAppService.openSystemSettingsLoginItems()
    }
}
