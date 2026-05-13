import Foundation
import Combine

final class DaysLeftState: ObservableObject {
    @Published var dateInfo: DateInfo
    @Published var displayText: String
    
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
