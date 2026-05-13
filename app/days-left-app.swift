import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var refreshService: MidnightRefreshService?
    
    func startRefreshService(for state: DaysLeftState) {
        refreshService = MidnightRefreshService {
            state.refresh()
        }
        refreshService?.start()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        refreshService?.stop()
    }
}

@main
struct DaysLeftApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var appState = DaysLeftState()
    
    var body: some Scene {
        MenuBarExtra("Days Left", systemImage: "calendar") {
            PopoverView()
                .environment(appState)
        }
        .menuBarExtraStyle(.window)
    }
}
