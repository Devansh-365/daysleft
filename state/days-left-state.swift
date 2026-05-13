import SwiftUI

@Observable
@MainActor
final class DaysLeftState {
    var dateInfo: DateInfo
    var displayText: String
    
    init(dateInfo: DateInfo = DateCalculationService.calculateAll(from: Date())) {
        self.dateInfo = dateInfo
        self.displayText = "\(dateInfo.yearDays)d"
    }
    
    func refresh() {
        let newInfo = DateCalculationService.calculateAll(from: Date())
        dateInfo = newInfo
        displayText = "\(newInfo.yearDays)d"
    }
}
