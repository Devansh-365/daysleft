import SwiftUI
import Combine

final class MidnightRefreshService {
    private var timer: AnyCancellable?
    private var wakeObserver: NSObjectProtocol?
    private var lastCheckedDay: Int
    private let onDayChanged: () -> Void
    
    init(onDayChanged: @escaping () -> Void) {
        self.onDayChanged = onDayChanged
        self.lastCheckedDay = Calendar.current.component(.day, from: Date())
    }
    
    func start() {
        let calendar = Calendar.current
        timer = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in
                let today = calendar.component(.day, from: now)
                if today != self?.lastCheckedDay {
                    self?.lastCheckedDay = today
                    self?.onDayChanged()
                }
            }
        
        wakeObserver = NSWorkspace.shared.notificationCenter
            .addObserver(forName: NSWorkspace.didWakeNotification, object: nil, queue: .main) { [weak self] _ in
                self?.lastCheckedDay = calendar.component(.day, from: Date())
                self?.onDayChanged()
            }
    }
    
    func stop() {
        timer?.cancel()
        timer = nil
        if let observer = wakeObserver {
            NSWorkspace.shared.notificationCenter.removeObserver(observer)
            wakeObserver = nil
        }
    }
    
    deinit {
        stop()
    }
}
