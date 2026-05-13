import SwiftUI

@main
struct DaysLeftApp: App {
    @State private var appState = DaysLeftState()
    
    var body: some Scene {
        MenuBarExtra("Days Left", systemImage: "calendar") {
            PopoverView()
                .environment(appState)
        }
        .menuBarExtraStyle(.window)
    }
}
