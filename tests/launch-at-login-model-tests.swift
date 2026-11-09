import XCTest
import ServiceManagement
@testable import days_left

private final class FakeLoginItemService: LoginItemService {
    var status: SMAppService.Status
    var registerError: Error?
    var unregisterError: Error?
    var registerCalls = 0
    /// Status macOS reports after a successful register (e.g. `.requiresApproval`).
    var statusAfterRegister: SMAppService.Status = .enabled

    init(status: SMAppService.Status) { self.status = status }

    func register() throws {
        registerCalls += 1
        if let registerError { throw registerError }
        status = statusAfterRegister
    }

    func unregister() throws {
        if let unregisterError { throw unregisterError }
        status = .notRegistered
    }
}

private struct SomeError: Error {}

final class LaunchAtLoginModelTests: XCTestCase {
    func testInitialState_comesFromSystemStatus() {
        XCTAssertTrue(LaunchAtLoginModel(service: FakeLoginItemService(status: .enabled)).isEnabled)
        XCTAssertFalse(LaunchAtLoginModel(service: FakeLoginItemService(status: .notRegistered)).isEnabled)
    }

    func testSetEnabled_success() {
        let fake = FakeLoginItemService(status: .notRegistered)
        let model = LaunchAtLoginModel(service: fake)
        model.setEnabled(true)
        XCTAssertTrue(model.isEnabled)
        XCTAssertNil(model.errorMessage)
    }

    func testSetEnabled_failure_toggleFlipsBackOff() {
        let fake = FakeLoginItemService(status: .notRegistered)
        fake.registerError = SomeError()
        let model = LaunchAtLoginModel(service: fake)
        model.setEnabled(true)
        XCTAssertFalse(model.isEnabled, "toggle must reflect reality, not the request")
        XCTAssertNotNil(model.errorMessage)
    }

    func testSetEnabled_requiresApproval() {
        let fake = FakeLoginItemService(status: .notRegistered)
        fake.statusAfterRegister = .requiresApproval
        let model = LaunchAtLoginModel(service: fake)
        model.setEnabled(true)
        XCTAssertFalse(model.isEnabled)
        XCTAssertTrue(model.needsApproval)
    }

    func testRefresh_picksUpChangeMadeInSystemSettings() {
        let fake = FakeLoginItemService(status: .enabled)
        let model = LaunchAtLoginModel(service: fake)
        fake.status = .notRegistered // user removed it in System Settings
        model.refresh()
        XCTAssertFalse(model.isEnabled)
    }

    func testNeverRegistersOnItsOwn() {
        // Creating the model and reading status must not touch login items.
        let fake = FakeLoginItemService(status: .notRegistered)
        let model = LaunchAtLoginModel(service: fake)
        model.refresh()
        XCTAssertEqual(fake.registerCalls, 0)
        XCTAssertFalse(model.isEnabled)
    }
}
