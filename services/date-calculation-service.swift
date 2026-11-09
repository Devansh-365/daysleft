import Foundation

/// Counts the days left in the current year, quarter, month and week.
///
/// **Every count includes today.** On the last day of a period the count is 1, never 0,
/// so the year, quarter, month and week rows always agree with each other
/// (on Dec 31 they all read 1).
///
/// The week follows `calendar.firstWeekday`, so it respects the user's region settings.
enum DateCalculationService {
    static func daysRemainingInYear(from date: Date, calendar: Calendar = .current) -> Int {
        daysUntilEnd(of: calendar.dateInterval(of: .year, for: date), from: date, calendar: calendar)
    }

    static func daysRemainingInQuarter(from date: Date, calendar: Calendar = .current) -> Int {
        // Calendar.dateInterval(of: .quarter, ...) isn't reliable in Foundation, so compute the bounds.
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let quarterStartMonth = ((month - 1) / 3) * 3 + 1
        guard let quarterStart = calendar.date(from: DateComponents(year: year, month: quarterStartMonth, day: 1)),
              let nextQuarterStart = calendar.date(byAdding: .month, value: 3, to: quarterStart) else {
            return 0
        }
        return daysBetween(calendar.startOfDay(for: date), nextQuarterStart, calendar: calendar)
    }

    static func daysRemainingInMonth(from date: Date, calendar: Calendar = .current) -> Int {
        daysUntilEnd(of: calendar.dateInterval(of: .month, for: date), from: date, calendar: calendar)
    }

    static func daysRemainingInWeek(from date: Date, calendar: Calendar = .current) -> Int {
        daysUntilEnd(of: calendar.dateInterval(of: .weekOfYear, for: date), from: date, calendar: calendar)
    }

    static func calculateAll(from date: Date, calendar: Calendar = .current) -> DateInfo {
        DateInfo(
            yearDays: daysRemainingInYear(from: date, calendar: calendar),
            quarterDays: daysRemainingInQuarter(from: date, calendar: calendar),
            monthDays: daysRemainingInMonth(from: date, calendar: calendar),
            weekDays: daysRemainingInWeek(from: date, calendar: calendar)
        )
    }

    // MARK: - Helpers

    /// Days from the start of today up to the start of the next period (exclusive end).
    private static func daysUntilEnd(of interval: DateInterval?, from date: Date, calendar: Calendar) -> Int {
        guard let interval else { return 0 }
        return daysBetween(calendar.startOfDay(for: date), interval.end, calendar: calendar)
    }

    private static func daysBetween(_ start: Date, _ end: Date, calendar: Calendar) -> Int {
        max(0, calendar.dateComponents([.day], from: start, to: calendar.startOfDay(for: end)).day ?? 0)
    }
}
