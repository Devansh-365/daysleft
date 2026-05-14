import Foundation
import Combine

final class DaysLeftState: ObservableObject {
    @Published var dateInfo: DateInfo
    @Published var displayText: String
    private var refreshService: MidnightRefreshService?
    
    init(dateInfo: DateInfo = DateCalculationService.calculateAll(from: Date())) {
        self.dateInfo = dateInfo
        self.displayText = "\(dateInfo.yearDays)d"
        self.refreshService = nil
    }
    
    func startRefreshService() {
        guard refreshService == nil else { return }
        refreshService = MidnightRefreshService { [weak self] in
            self?.refresh()
        }
        refreshService?.start()
    }
    
    func refresh() {
        let newInfo = DateCalculationService.calculateAll(from: Date())
        dateInfo = newInfo
        displayText = "\(newInfo.yearDays)d"
    }
}
