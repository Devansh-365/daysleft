import XCTest
@testable import days_left

final class DayCountTextTests: XCTestCase {
    func testDays_pluralization() {
        XCTAssertEqual(DayCountText.days(0), "0 days")
        XCTAssertEqual(DayCountText.days(1), "1 day")
        XCTAssertEqual(DayCountText.days(2), "2 days")
        XCTAssertEqual(DayCountText.days(365), "365 days")
    }

    func testLeft_sentences() {
        XCTAssertEqual(DayCountText.left(1, in: .year), "1 day left in the year")
        XCTAssertEqual(DayCountText.left(53, in: .quarter), "53 days left in the quarter")
        XCTAssertEqual(DayCountText.left(22, in: .month), "22 days left in the month")
        XCTAssertEqual(DayCountText.left(1, in: .week), "1 day left in the week")
    }

    func testMenuBarFormat_text() {
        XCTAssertEqual(MenuBarFormat.compact.text(for: 53), "53d")
        XCTAssertEqual(MenuBarFormat.words.text(for: 53), "53 days")
        XCTAssertEqual(MenuBarFormat.words.text(for: 1), "1 day")
        XCTAssertEqual(MenuBarFormat.number.text(for: 53), "53")
    }

    func testMenuBarFormat_defaultIsCompact() {
        XCTAssertEqual(MenuBarFormat.default, .compact)
    }
}
