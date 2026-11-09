import XCTest
@testable import days_left

final class DaysLeftStateTests: XCTestCase {
    private var defaults: UserDefaults!
    private var suiteName: String!
    private let calendar = DateCalculationServiceTests.sundayFirst

    override func setUp() {
        super.setUp()
        suiteName = "DaysLeftStateTests-\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    private func date(_ y: Int, _ m: Int, _ d: Int) -> Date {
        calendar.date(from: DateComponents(year: y, month: m, day: d, hour: 12))!
    }

    private func makeState(at date: Date) -> DaysLeftState {
        DaysLeftState(now: { date }, calendar: calendar, defaults: defaults, startsRefresh: false)
    }

    func testInjectedDate_drivesDateInfo() {
        let state = makeState(at: date(2026, 11, 9))
        XCTAssertEqual(state.dateInfo, DateInfo(yearDays: 53, quarterDays: 53, monthDays: 22, weekDays: 6))
        XCTAssertEqual(state.displayText, "53d")
        XCTAssertEqual(state.accessibilityText, "53 days left in the year")
    }

    func testNewYearsEve_singularAndConsistent() {
        let state = makeState(at: date(2026, 12, 31))
        XCTAssertEqual(state.dateInfo.yearDays, 1)
        XCTAssertEqual(state.dateInfo.monthDays, 1)
        XCTAssertEqual(state.displayText, "1d")
        XCTAssertEqual(state.accessibilityText, "1 day left in the year")
    }

    func testRefresh_usesClockAgain_acrossNewYear() {
        var current = date(2026, 12, 31)
        let state = DaysLeftState(now: { current }, calendar: calendar, defaults: defaults, startsRefresh: false)
        XCTAssertEqual(state.dateInfo.yearDays, 1)

        current = date(2027, 1, 1)
        state.refresh()
        XCTAssertEqual(state.dateInfo.yearDays, 365)
        XCTAssertEqual(state.displayText, "365d")
    }

    func testMenuBarFormat_changesTextAndPersists() {
        let state = makeState(at: date(2026, 11, 9))
        state.menuBarFormat = .words
        XCTAssertEqual(state.displayText, "53 days")
        XCTAssertEqual(state.accessibilityText, "53 days left in the year", "VoiceOver text ignores the visual format")
        XCTAssertEqual(defaults.string(forKey: DaysLeftState.Keys.menuBarFormat), "words")

        let reloaded = makeState(at: date(2026, 11, 9))
        XCTAssertEqual(reloaded.menuBarFormat, .words)
        XCTAssertEqual(reloaded.displayText, "53 days")
    }

    func testUnknownStoredFormat_fallsBackToDefault() {
        defaults.set("bogus", forKey: DaysLeftState.Keys.menuBarFormat)
        let state = makeState(at: date(2026, 11, 9))
        XCTAssertEqual(state.menuBarFormat, .compact)
    }
}
