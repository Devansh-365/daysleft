import Foundation
import Combine

/// Single source of truth for what the menu bar and the dropdown show.
final class DaysLeftState: ObservableObject {
    enum Keys {
        static let menuBarFormat = "menuBarFormat"
    }

    @Published private(set) var dateInfo: DateInfo
    /// Visible menu bar text, e.g. "53d".
    @Published private(set) var displayText: String
    /// What VoiceOver reads for the menu bar item, e.g. "53 days left in the year".
    @Published private(set) var accessibilityText: String
    /// Persisted user choice for the menu bar text.
    @Published var menuBarFormat: MenuBarFormat {
        didSet {
            defaults.set(menuBarFormat.rawValue, forKey: Keys.menuBarFormat)
            updateText()
        }
    }

    private let now: () -> Date
    private let calendar: Calendar
    private let defaults: UserDefaults
    private var refreshService: MidnightRefreshService?

    /// - Parameters:
    ///   - now: Clock. Tests inject a fixed date; the app uses the real one.
    ///   - calendar: Defaults to the user's calendar, updating when they change region or time zone.
    ///   - defaults: Where the menu bar format is stored.
    ///   - startsRefresh: Pass `false` in tests so no timers or observers are started.
    init(
        now: @escaping () -> Date = Date.init,
        calendar: Calendar = .autoupdatingCurrent,
        defaults: UserDefaults = .standard,
        startsRefresh: Bool = true
    ) {
        self.now = now
        self.calendar = calendar
        self.defaults = defaults

        let format = defaults.string(forKey: Keys.menuBarFormat).flatMap(MenuBarFormat.init(rawValue:)) ?? .default
        let info = DateCalculationService.calculateAll(from: now(), calendar: calendar)
        self.menuBarFormat = format
        self.dateInfo = info
        self.displayText = format.text(for: info.yearDays)
        self.accessibilityText = DayCountText.left(info.yearDays, in: .year)

        if startsRefresh {
            let service = MidnightRefreshService(calendar: calendar, now: now) { [weak self] in
                self?.refresh()
            }
            service.start()
            refreshService = service
        }
    }

    func refresh() {
        dateInfo = DateCalculationService.calculateAll(from: now(), calendar: calendar)
        updateText()
    }

    private func updateText() {
        displayText = menuBarFormat.text(for: dateInfo.yearDays)
        accessibilityText = DayCountText.left(dateInfo.yearDays, in: .year)
    }
}
