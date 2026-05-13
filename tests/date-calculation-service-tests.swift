import XCTest
@testable import days_left

final class DateCalculationServiceTests: XCTestCase {
    let calendar = Calendar.current
    
    func testDaysRemainingInYear_forFutureDate() {
        let date = calendar.date(from: DateComponents(year: 2025, month: 1, day: 1))!
        let result = DateCalculationService.daysRemainingInYear(from: date)
        XCTAssertEqual(result, 365)
    }
    
    func testDaysRemainingInYear_forLeapYear() {
        let date = calendar.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        let result = DateCalculationService.daysRemainingInYear(from: date)
        XCTAssertEqual(result, 366)
    }
    
    func testDaysRemainingInYear_forLastDay() {
        let date = calendar.date(from: DateComponents(year: 2025, month: 12, day: 31))!
        let result = DateCalculationService.daysRemainingInYear(from: date)
        XCTAssertEqual(result, 1)
    }
    
    func testDaysRemainingInMonth_forFirstDay() {
        let date = calendar.date(from: DateComponents(year: 2025, month: 3, day: 1))!
        let result = DateCalculationService.daysRemainingInMonth(from: date)
        XCTAssertEqual(result, 30)
    }
    
    func testDaysRemainingInMonth_forLastDay() {
        let date = calendar.date(from: DateComponents(year: 2025, month: 3, day: 31))!
        let result = DateCalculationService.daysRemainingInMonth(from: date)
        XCTAssertEqual(result, 0)
    }
    
    func testDaysRemainingInWeek_forMonday() {
        let date = calendar.date(from: DateComponents(year: 2025, month: 1, day: 6))!
        let result = DateCalculationService.daysRemainingInWeek(from: date)
        XCTAssertEqual(result, 5)
    }
    
    func testDaysRemainingInWeek_forSunday() {
        let date = calendar.date(from: DateComponents(year: 2025, month: 1, day: 12))!
        let result = DateCalculationService.daysRemainingInWeek(from: date)
        XCTAssertEqual(result, 6)
    }
    
    func testCalculateAll() {
        let date = calendar.date(from: DateComponents(year: 2025, month: 1, day: 1))!
        let result = DateCalculationService.calculateAll(from: date)
        XCTAssertEqual(result.yearDays, 365)
        XCTAssertEqual(result.monthDays, 30)
        XCTAssertEqual(result.weekDays, 3)
    }
}
