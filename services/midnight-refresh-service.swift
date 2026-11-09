import AppKit
import Combine

/// Tells the app when the date it shows might be stale.
///
/// Triggers:
/// - `.NSCalendarDayChanged`: the calendar day rolled over (midnight).
/// - `.NSSystemClockDidChange`: the user or the network changed the clock.
/// - `.NSSystemTimeZoneDidChange`: the user travelled or changed the time zone.
/// - `NSWorkspace.didWakeNotification`: the Mac woke from sleep.
/// - A 60-second timer as a safety net, which fires only when the day actually changed.
final class MidnightRefreshService {
    private let calendar: Calendar
    private let now: () -> Date
    private let notificationCenter: NotificationCenter
    private let workspaceCenter: NotificationCenter
    private let onDayChanged: () -> Void

    private var timer: AnyCancellable?
    private var observers: [(NotificationCenter, NSObjectProtocol)] = []
    private var lastSeenDate: Date

    private(set) var isRunning = false

    init(
        calendar: Calendar = .autoupdatingCurrent,
        now: @escaping () -> Date = Date.init,
        notificationCenter: NotificationCenter = .default,
        workspaceCenter: NotificationCenter = NSWorkspace.shared.notificationCenter,
        onDayChanged: @escaping () -> Void
    ) {
        self.calendar = calendar
        self.now = now
        self.notificationCenter = notificationCenter
        self.workspaceCenter = workspaceCenter
        self.onDayChanged = onDayChanged
        self.lastSeenDate = now()
    }

    func start() {
        guard !isRunning else { return } // never register observers twice
        isRunning = true
        lastSeenDate = now()

        timer = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.refreshIfDayChanged() }

        let systemEvents: [Notification.Name] = [
            .NSCalendarDayChanged,
            .NSSystemClockDidChange,
            .NSSystemTimeZoneDidChange,
        ]
        for name in systemEvents {
            observe(name, on: notificationCenter)
        }
        observe(NSWorkspace.didWakeNotification, on: workspaceCenter)
    }

    func stop() {
        timer?.cancel()
        timer = nil
        for (center, token) in observers {
            center.removeObserver(token)
        }
        observers.removeAll()
        isRunning = false
    }

    deinit {
        stop()
    }

    // MARK: - Private

    private func observe(_ name: Notification.Name, on center: NotificationCenter) {
        // Some of these are posted on background threads; always hop to main.
        let token = center.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
            self?.refreshNow()
        }
        observers.append((center, token))
    }

    private func refreshNow() {
        lastSeenDate = now()
        onDayChanged()
    }

    private func refreshIfDayChanged() {
        let current = now()
        guard !calendar.isDate(current, inSameDayAs: lastSeenDate) else { return }
        lastSeenDate = current
        onDayChanged()
    }
}
