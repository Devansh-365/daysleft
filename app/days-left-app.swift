import SwiftUI

@main
struct DaysLeftApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        MenuBarExtra {
            PopoverView()
                .environmentObject(appDelegate.state)
        } label: {
            MenuBarLabel(state: appDelegate.state)
        }
        .menuBarExtraStyle(.window)
    }
}

/// Visible text stays compact ("53d"); VoiceOver hears "53 days left in the year".
private struct MenuBarLabel: View {
    @ObservedObject var state: DaysLeftState

    var body: some View {
        Text(state.displayText)
            .monospacedDigit()
            .accessibilityLabel(state.accessibilityText)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    let state = DaysLeftState()
    private var keyMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        installKeyboardShortcuts()
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let keyMonitor {
            NSEvent.removeMonitor(keyMonitor)
        }
    }

    /// ⌘, opens Settings, ⌘Q quits, ⌘W closes the Settings window.
    ///
    /// The dropdown is a `.window`-style MenuBarExtra panel, where SwiftUI's
    /// `.keyboardShortcut` isn't reliably delivered. A local event monitor sees key events
    /// for every window this app owns (the dropdown and Settings) and is removed on quit.
    private func installKeyboardShortcuts() {
        keyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self else { return event }
            let modifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            guard modifiers == .command, let key = event.charactersIgnoringModifiers?.lowercased() else {
                return event
            }
            switch key {
            case ",":
                SettingsWindowController.shared.show(state: self.state)
                return nil
            case "q":
                NSApp.terminate(nil)
                return nil
            case "w" where SettingsWindowController.shared.isSettingsWindowKey:
                SettingsWindowController.shared.close()
                return nil
            default:
                return event
            }
        }
    }
}
