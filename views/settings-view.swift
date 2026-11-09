import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var state: DaysLeftState
    @EnvironmentObject var launchAtLogin: LaunchAtLoginModel

    var body: some View {
        Form {
            Section {
                Picker("Show as", selection: $state.menuBarFormat) {
                    ForEach(MenuBarFormat.allCases) { format in
                        Text(format.text(for: state.dateInfo.yearDays)).tag(format)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Menu bar")
            } footer: {
                Text("VoiceOver always reads the full sentence.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section {
                Toggle("Launch at login", isOn: Binding(
                    get: { launchAtLogin.isEnabled },
                    set: { launchAtLogin.setEnabled($0) }
                ))

                if launchAtLogin.needsApproval {
                    HStack {
                        Text("Allow Days Left in Login Items to finish turning this on.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button("Open Login Items") { launchAtLogin.openLoginItemsSettings() }
                    }
                }

                if let message = launchAtLogin.errorMessage {
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("General")
            }
        }
        .formStyle(.grouped)
        .frame(width: 380)
        .fixedSize(horizontal: false, vertical: true)
        .onAppear { launchAtLogin.refresh() }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { _ in
            // The user may have changed Login Items in System Settings while this window was closed.
            launchAtLogin.refresh()
        }
    }
}

/// Owns the one Settings window. Opening it again brings the same window to the front.
final class SettingsWindowController {
    static let shared = SettingsWindowController()

    private var window: NSWindow?

    var isSettingsWindowKey: Bool {
        guard let window else { return false }
        return window.isKeyWindow
    }

    func show(state: DaysLeftState) {
        if window == nil {
            let root = SettingsView()
                .environmentObject(state)
                .environmentObject(LaunchAtLoginModel.shared)
            let window = NSWindow(contentViewController: NSHostingController(rootView: root))
            window.title = "Days Left Settings"
            window.styleMask = [.titled, .closable]
            window.isReleasedWhenClosed = false // keep it alive so reopening is safe
            window.center()
            self.window = window
        }

        // An app without a Dock icon must activate itself, or the window opens behind other apps.
        if #available(macOS 14.0, *) {
            NSApp.activate()
        } else {
            NSApp.activate(ignoringOtherApps: true)
        }
        window?.makeKeyAndOrderFront(nil)
    }

    func close() {
        window?.performClose(nil)
    }
}
