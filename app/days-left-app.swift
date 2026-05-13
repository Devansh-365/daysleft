import SwiftUI

@main
struct DaysLeftApp: App {
    @StateObject private var appState = DaysLeftState()
    
    var body: some Scene {
        MenuBarExtra("Days Left", systemImage: "calendar") {
            PopoverView()
                .environmentObject(appState)
        }
        .menuBarExtraStyle(.window)
    }
}
