import SwiftUI

struct PopoverView: View {
    @EnvironmentObject var state: DaysLeftState

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            VStack(alignment: .leading, spacing: 2) {
                row(state.dateInfo.yearDays, .year)
                row(state.dateInfo.quarterDays, .quarter)
                row(state.dateInfo.monthDays, .month)
                row(state.dateInfo.weekDays, .week)
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Days left")

            Divider()
                .padding(.vertical, 6)
                .padding(.horizontal, 8)

            Button {
                SettingsWindowController.shared.show(state: state)
            } label: {
                MenuItemLabel(title: "Preferences…", shortcut: "⌘,")
            }
            .buttonStyle(MenuItemButtonStyle())
            .accessibilityHint("Opens the Days Left settings window")

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                MenuItemLabel(title: "Quit Days Left", shortcut: "⌘Q")
            }
            .buttonStyle(MenuItemButtonStyle())
            .accessibilityHint("Quits Days Left")
        }
        .padding(12)
        .frame(width: 260)
    }

    private func row(_ count: Int, _ period: DayCountText.Period) -> some View {
        Text(DayCountText.left(count, in: period))
            .monospacedDigit()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Title on the left, shortcut hint on the right, like a native menu item.
private struct MenuItemLabel: View {
    let title: String
    let shortcut: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(shortcut)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
        }
    }
}

/// Full-width menu row with a hover highlight. The highlight is instant when Reduce Motion is on.
struct MenuItemButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        MenuItemRow(configuration: configuration)
    }

    private struct MenuItemRow: View {
        let configuration: ButtonStyleConfiguration
        @State private var isHovered = false
        @Environment(\.accessibilityReduceMotion) private var reduceMotion

        var body: some View {
            configuration.label
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(Color.accentColor.opacity(highlightOpacity))
                )
                .onHover { isHovered = $0 }
                .animation(reduceMotion ? nil : .easeOut(duration: 0.12), value: isHovered)
        }

        private var highlightOpacity: Double {
            if configuration.isPressed { return 0.25 }
            return isHovered ? 0.14 : 0
        }
    }
}
