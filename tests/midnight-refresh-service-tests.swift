import XCTest
import AppKit
@testable import days_left

final class MidnightRefreshServiceTests: XCTestCase {
    private var center: NotificationCenter!
    private var workspace: NotificationCenter!

    override func setUp() {
        super.setUp()
        center = NotificationCenter()
        workspace = NotificationCenter()
    }

    private func makeService(onChange: @escaping () -> Void) -> MidnightRefreshService {
        MidnightRefreshService(
            calendar: DateCalculationServiceTests.sundayFirst,
            notificationCenter: center,
            workspaceCenter: workspace,
            onDayChanged: onChange
        )
    }

    private func assertRefreshes(on name: Notification.Name, from source: NotificationCenter,
                                 file: StaticString = #filePath, line: UInt = #line) {
        let fired = expectation(description: "refresh for \(name.rawValue)")
        let service = makeService { fired.fulfill() }
        service.start()
        source.post(name: name, object: nil)
        wait(for: [fired], timeout: 1)
        service.stop()
    }

    func testCalendarDayChanged_triggersRefresh() {
        assertRefreshes(on: .NSCalendarDayChanged, from: center)
    }

    func testSystemClockChanged_triggersRefresh() {
        assertRefreshes(on: .NSSystemClockDidChange, from: center)
    }

    func testTimeZoneChanged_triggersRefresh() {
        assertRefreshes(on: .NSSystemTimeZoneDidChange, from: center)
    }

    func testWake_triggersRefresh() {
        assertRefreshes(on: NSWorkspace.didWakeNotification, from: workspace)
    }

    func testStartTwice_doesNotDuplicateObservers() {
        var count = 0
        let fired = expectation(description: "refresh")
        let service = makeService {
            count += 1
            fired.fulfill()
        }
        service.start()
        service.start()
        center.post(name: .NSCalendarDayChanged, object: nil)
        wait(for: [fired], timeout: 1)
        // Let any duplicate deliveries on the main queue run before checking.
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))
        XCTAssertEqual(count, 1)
        service.stop()
    }

    func testStop_removesObservers() {
        var count = 0
        let service = makeService { count += 1 }
        service.start()
        service.stop()
        XCTAssertFalse(service.isRunning)
        center.post(name: .NSCalendarDayChanged, object: nil)
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))
        XCTAssertEqual(count, 0)
    }
}
