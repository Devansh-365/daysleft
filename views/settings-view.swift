import SwiftUI

struct SettingsView: View {
    @AppStorage("launchAtLogin") var launchAtLogin: Bool = true
    
    var body: some View {
        Form {
            Toggle("Launch at Login", isOn: $launchAtLogin)
        }
        .padding()
        .frame(width: 300, height: 100)
    }
}
