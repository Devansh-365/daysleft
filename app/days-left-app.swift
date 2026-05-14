import SwiftUI

@main
struct DaysLeftApp: App {
    @StateObject private var appState = DaysLeftState()
    
    init() {
        appState.startRefreshService()
    }
    
    var body: some Scene {
        MenuBarExtra(appState.displayText) {
            PopoverView()
                .environmentObject(appState)
        }
        .menuBarExtraStyle(.window)
    }
}
