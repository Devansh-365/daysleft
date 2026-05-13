import Foundation

struct DateCalculationService {
    static func daysRemainingInYear(from date: Date) -> Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        guard let endOfYear = calendar.date(from: DateComponents(year: year + 1, month: 1, day: 1)) else {
            return 0
        }
        let startOfDay = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: startOfDay, to: endOfYear)
        return max(0, components.day ?? 0)
    }
    
    static func daysRemainingInMonth(from date: Date) -> Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: startOfDay),
              let endOfMonth = calendar.date(byAdding: .day, value: -calendar.component(.day, from: nextMonth), to: nextMonth) else {
            return 0
        }
        let components = calendar.dateComponents([.day], from: startOfDay, to: endOfMonth)
        return max(0, components.day ?? 0)
    }
    
    static func daysRemainingInWeek(from date: Date) -> Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let firstWeekday = calendar.firstWeekday
        let daysFromStart = (weekday - firstWeekday + 7) % 7
        return 6 - daysFromStart
    }
    
    static func calculateAll(from date: Date) -> DateInfo {
        DateInfo(
            yearDays: daysRemainingInYear(from: date),
            monthDays: daysRemainingInMonth(from: date),
            weekDays: daysRemainingInWeek(from: date)
        )
    }
}
