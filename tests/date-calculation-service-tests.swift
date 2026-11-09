import XCTest
@testable import days_left

/// Every test uses a pinned calendar so results don't depend on the machine's locale,
/// time zone or first weekday. All counts include today (the last day of a period is 1).
final class DateCalculationServiceTests: XCTestCase {

    // MARK: - Fixtures

    /// Gregorian, UTC, weeks starting on Sunday.
    static let sundayFirst = pinnedCalendar(firstWeekday: 1)
    /// Gregorian, UTC, weeks starting on Monday.
    static let mondayFirst = pinnedCalendar(firstWeekday: 2)

    static func pinnedCalendar(firstWeekday: Int) -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.firstWeekday = firstWeekday
        return calendar
    }

    private func date(_ year: Int, _ month: Int, _ day: Int, hour: Int = 12,
                      in calendar: Calendar = sundayFirst) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour))!
    }

    private let cal = DateCalculationServiceTests.sundayFirst

    // MARK: - Year

    func testYear_firstDayOfCommonYear_is365() {
        XCTAssertEqual(DateCalculationService.daysRemainingInYear(from: date(2025, 1, 1), calendar: cal), 365)
    }

    func testYear_firstDayOfLeapYear_is366() {
        XCTAssertEqual(DateCalculationService.daysRemainingInYear(from: date(2024, 1, 1), calendar: cal), 366)
    }

    func testYear_lastDay_is1() {
        XCTAssertEqual(DateCalculationService.daysRemainingInYear(from: date(2026, 12, 31), calendar: cal), 1)
    }

    func testYear_lateEvening_stillCountsToday() {
        XCTAssertEqual(DateCalculationService.daysRemainingInYear(from: date(2026, 12, 31, hour: 23), calendar: cal), 1)
    }

    func testYear_leapDay() {
        // 2028-02-29 is day 60 of 366 → 307 days left including today.
        XCTAssertEqual(DateCalculationService.daysRemainingInYear(from: date(2028, 2, 29), calendar: cal), 307)
    }

    // MARK: - Month

    func testMonth_firstDayOf31DayMonth_is31() {
        XCTAssertEqual(DateCalculationService.daysRemainingInMonth(from: date(2025, 3, 1), calendar: cal), 31)
    }

    func testMonth_lastDay_is1() {
        XCTAssertEqual(DateCalculationService.daysRemainingInMonth(from: date(2025, 3, 31), calendar: cal), 1)
    }

    func testMonth_lastDayOfEveryMonth_is1() {
        for month in 1...12 {
            let lastDay = cal.range(of: .day, in: .month, for: date(2026, month, 1))!.count
            XCTAssertEqual(
                DateCalculationService.daysRemainingInMonth(from: date(2026, month, lastDay), calendar: cal), 1,
                "month \(month)"
            )
        }
    }

    func testMonth_february_commonAndLeap() {
        XCTAssertEqual(DateCalculationService.daysRemainingInMonth(from: date(2026, 2, 28), calendar: cal), 1)
        XCTAssertEqual(DateCalculationService.daysRemainingInMonth(from: date(2028, 2, 28), calendar: cal), 2)
        XCTAssertEqual(DateCalculationService.daysRemainingInMonth(from: date(2028, 2, 29), calendar: cal), 1)
    }

    func testMonth_day30Of31_is2() {
        // The old "add a month, subtract days" math was fragile around month ends.
        XCTAssertEqual(DateCalculationService.daysRemainingInMonth(from: date(2026, 1, 30), calendar: cal), 2)
    }

    // MARK: - Week (Sunday-first)

    func testWeek_sundayFirst_sunday_is7() {
        // 2025-01-12 is a Sunday.
        XCTAssertEqual(DateCalculationService.daysRemainingInWeek(from: date(2025, 1, 12), calendar: cal), 7)
    }

    func testWeek_sundayFirst_monday_is6() {
        // 2025-01-06 is a Monday.
        XCTAssertEqual(DateCalculationService.daysRemainingInWeek(from: date(2025, 1, 6), calendar: cal), 6)
    }

    func testWeek_sundayFirst_saturday_is1() {
        // 2025-01-11 is a Saturday.
        XCTAssertEqual(DateCalculationService.daysRemainingInWeek(from: date(2025, 1, 11), calendar: cal), 1)
    }

    // MARK: - Week (Monday-first)

    func testWeek_mondayFirst_monday_is7() {
        let mon = Self.mondayFirst
        XCTAssertEqual(DateCalculationService.daysRemainingInWeek(from: date(2025, 1, 6, in: mon), calendar: mon), 7)
    }

    func testWeek_mondayFirst_sunday_is1() {
        let mon = Self.mondayFirst
        XCTAssertEqual(DateCalculationService.daysRemainingInWeek(from: date(2025, 1, 12, in: mon), calendar: mon), 1)
    }

    func testWeek_acrossYearBoundary() {
        // 2026-12-31 is a Thursday: Thu, Fri, Sat left in a Sunday-first week.
        XCTAssertEqual(DateCalculationService.daysRemainingInWeek(from: date(2026, 12, 31), calendar: cal), 3)
    }

    // MARK: - Quarter

    func testQuarter_firstDayOfQ1_commonYear_is90() {
        XCTAssertEqual(DateCalculationService.daysRemainingInQuarter(from: date(2026, 1, 1), calendar: cal), 90)
    }

    func testQuarter_firstDayOfQ1_leapYear_is91() {
        XCTAssertEqual(DateCalculationService.daysRemainingInQuarter(from: date(2028, 1, 1), calendar: cal), 91)
    }

    func testQuarter_lastDayOfEachQuarter_is1() {
        XCTAssertEqual(DateCalculationService.daysRemainingInQuarter(from: date(2026, 3, 31), calendar: cal), 1)
        XCTAssertEqual(DateCalculationService.daysRemainingInQuarter(from: date(2026, 6, 30), calendar: cal), 1)
        XCTAssertEqual(DateCalculationService.daysRemainingInQuarter(from: date(2026, 9, 30), calendar: cal), 1)
        XCTAssertEqual(DateCalculationService.daysRemainingInQuarter(from: date(2026, 12, 31), calendar: cal), 1)
    }

    func testQuarter_midQ4() {
        // 2026-11-09: 22 days left in November + 31 in December.
        XCTAssertEqual(DateCalculationService.daysRemainingInQuarter(from: date(2026, 11, 9), calendar: cal), 53)
    }

    // MARK: - All at once

    func testCalculateAll_newYearsEve_everyCountIsAtLeast1() {
        let info = DateCalculationService.calculateAll(from: date(2026, 12, 31), calendar: cal)
        XCTAssertEqual(info, DateInfo(yearDays: 1, quarterDays: 1, monthDays: 1, weekDays: 3))
    }

    func testCalculateAll_firstOfJanuary2025() {
        // 2025-01-01 is a Wednesday.
        let info = DateCalculationService.calculateAll(from: date(2025, 1, 1), calendar: cal)
        XCTAssertEqual(info, DateInfo(yearDays: 365, quarterDays: 90, monthDays: 31, weekDays: 4))
    }

    func testDefaultCalendarParameter_stillWorks() {
        // Public API without an explicit calendar keeps working (uses Calendar.current).
        let value = DateCalculationService.daysRemainingInYear(from: Date())
        XCTAssertTrue((1...366).contains(value))
    }
}
