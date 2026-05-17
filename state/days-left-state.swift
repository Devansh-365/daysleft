import Foundation
import Combine

final class DaysLeftState: ObservableObject {
    @Published var dateInfo: DateInfo
    @Published var displayText: String
    private var refreshService: MidnightRefreshService?

    init() {
        let info = DateCalculationService.calculateAll(from: Date())
        self.dateInfo = info
        self.displayText = "\(info.yearDays)d"
        self.refreshService = nil
        let service = MidnightRefreshService { [weak self] in
            self?.refresh()
        }
        service.start()
        self.refreshService = service
    }

    func refresh() {
        let newInfo = DateCalculationService.calculateAll(from: Date())
        dateInfo = newInfo
        displayText = "\(newInfo.yearDays)d"
    }
}
