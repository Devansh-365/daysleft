import Foundation

/// Days left in each period. Every value includes today.
struct DateInfo: Equatable {
    let yearDays: Int
    let quarterDays: Int
    let monthDays: Int
    let weekDays: Int
}
