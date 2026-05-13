import SwiftUI

struct PopoverView: View {
    @Environment(DaysLeftState.self) private var state
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(state.dateInfo.yearDays) days left in the year")
            Text("\(state.dateInfo.monthDays) days left in the month")
            Text("\(state.dateInfo.weekDays) days left in the week")
            
            Divider()
            
            Button("Preferences...") {
                openSettings()
            }
            .buttonStyle(.plain)
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .frame(width: 240)
    }
    
    private func openSettings() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 150),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Preferences"
        window.contentView = NSHostingView(rootView: SettingsView())
        window.center()
        window.makeKeyAndOrderFront(nil)
    }
}
