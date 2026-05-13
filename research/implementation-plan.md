# Days Left — Implementation Plan

> **Purpose:** Phased build plan with parallel task groups, layered architecture, and git commit checkpoints.
> **Scope:** macOS 13+ menu bar utility. v1 MVP only.

---

## 1. Tech Stack & Architecture

### Tech Stack

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **UI Framework** | SwiftUI `MenuBarExtra(.window)` | Native macOS 13+, covers 100% of v1 needs. No AppKit required. |
| **Language** | Swift 6 | Strict concurrency, modern syntax, Xcode 16+ native. |
| **Architecture** | Layered MVVM — `@Observable` AppState + Services | Minimal boilerplate, clear separation, testable. |
| **Persistence** | `@AppStorage` (UserDefaults) | Trivial data (<1KB). No database needed. |
| **Launch at Login** | `SMAppService.mainApp.register()` | Modern macOS 13+ API. Correct System Settings semantics. |
| **Midnight Updates** | `Timer.publish(every: 60)` + `NSWorkspace.didWakeNotification` | Handles sleep/wake, minimal CPU/power impact. |
| **Distribution** | Developer ID (direct) + Mac App Store dual config | Start direct (simpler), App Store later. |
| **Testing** | XCTest for Services/ViewModels + Manual QA for UI | NSStatusItem asserts in test context — isolate logic. |
| **Dependencies** | Zero third-party | Foundation + SwiftUI covers everything. |

### Reference Templates

| Template | Use For | URL |
|----------|---------|-----|
| **BuildBar** | Production architecture reference (MVVM, services, tests) | github.com/Kobe/BuildBar |
| **macOS Menu Bar Xcode Template** | Clean Swift 6 starting slate | github.com/the-trumpeter/MacOS-menu-bar-app-XCode-template |
| **UpNext** | Clean `@Observable` pattern, thin ViewModel | github.com/srichand/UpNext |

---

## 2. Layered Architecture

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  content-view, popover-view, settings-view │
├─────────────────────────────────────────┤
│       Presentation Logic Layer          │
│  days-left-state (@Observable)            │
├─────────────────────────────────────────┤
│         Business Logic Layer            │
│  date-calculation-service                 │
│  midnight-refresh-service                 │
│  launch-at-login-service                   │
├─────────────────────────────────────────┤
│          Data/Persistence Layer         │
│  @AppStorage wrappers                   │
│  app-settings (Codable)                  │
└─────────────────────────────────────────┘
```

### Data Flow (Unidirectional)

```
[Timer / Wake Notification] → date-calculation-service → days-left-state → Views
                                    ↕
                              @AppStorage (persistence)
```

### Concern Map

| Layer | Folder | What Lives Here | Imports |
|-------|--------|----------------|---------|
| **Presentation** | `Views/` | SwiftUI views, popover layout | `SwiftUI` only |
| **Presentation Logic** | `State/` | `@Observable` classes, computed display strings, drives menu bar label | `Models`, `Foundation` |
| **Business Logic** | `Services/` | Date math, refresh scheduling, login toggle | `Foundation` only |
| **Data** | `Models/` | `date-info` struct, `app-settings` | `Foundation` |
| **App Shell** | `App/` | `@main` entry point, scene config | `SwiftUI`, `AppKit` |
| **Shared** | `Utilities/` | Formatters, extensions, constants | `Foundation` |

---

## 3. Folder Structure

```
days-left/
├── app/
│   └── days-left-app.swift               # @main entry point, MenuBarExtra scene
│
├── state/
│   └── days-left-state.swift             # @Observable — single source of truth, drives menu bar label + popover data
│
├── views/
│   ├── popover-view.swift               # Dropdown: year/month/week + prefs/quit
│   └── settings-view.swift              # Preferences window (Launch at Login)
│
├── services/
│   ├── date-calculation-service.swift    # Pure logic: days remaining (struct)
│   ├── midnight-refresh-service.swift    # Timer + wake notification management
│   └── launch-at-login-service.swift      # SMAppService wrapper
│
├── models/
│   ├── date-info.swift                  # Pure struct: days in year/month/week
│   └── app-settings.swift               # @AppStorage-backed settings model
│
├── utilities/
│   └── date-formatters.swift            # Shared formatting helpers
│
└── resources/
    ├── Assets.xcassets
    ├── Info.plist                      # LSUIElement = YES
    └── days-left.entitlements
```

---

## 4. Phased Implementation Plan

> **Legend:**
> - `CP` = Checkpoint (git commit)
> - Tasks in **Parallel Group** can run simultaneously
> - Dependencies flow down — later phases depend on earlier ones

---

### Phase 0 — Project Scaffold
**Goal:** Create the Xcode project, configure build settings, set up git, establish folder structure.
**Estimated Effort:** 1-2 hours

#### Parallel Group 0A
- [ ] Create new Xcode project: macOS → App → SwiftUI interface, Swift 6, min macOS 13.0
- [ ] Configure `Info.plist`: `LSUIElement = YES` (no Dock icon)
- [ ] Set `CFBundleName = "Days Left"`, `CFBundleIdentifier = com.yourname.daysleft`
- [ ] Configure signing: create/assign Team, set Bundle ID

#### Parallel Group 0B
- [ ] Create folder structure: `App/`, `State/`, `Views/`, `Services/`, `Models/`, `Utilities/`, `Resources/`
- [ ] Add `.gitignore` for Swift/Xcode (DerivedData, xcuserdata, build products)
- [ ] Add `README.md` with app description, build instructions, architecture overview

#### Sequential
- [ ] Verify build compiles with zero errors
- [ ] Verify app launches with no Dock icon (`LSUIElement` working)

**CP-0:** `git add . && git commit -m "feat: scaffold days-left xcode project with layered architecture folders"`

---

### Phase 1 — Core Date Logic & Menu Bar Display
**Goal:** The app shows "47d" in the menu bar. Date calculations are correct and tested.
**Estimated Effort:** 2-3 hours
**Depends on:** Phase 0
**Note:** Steps 1A → 1B → 1C are sequential (each depends on the previous).

#### Step 1A — Business Logic (first)
- [ ] Implement `date-calculation-service` (struct, static methods):
  - `daysRemainingInYear(from: Date) -> Int`
  - `daysRemainingInMonth(from: Date) -> Int`
  - `daysRemainingInWeek(from: Date) -> Int`
  - **Note:** Week calculation uses `Calendar.current.firstWeekday` (system locale). Document this behavior.
- [ ] Implement `date-info` struct (pure data: `yearDays`, `monthDays`, `weekDays`)
- [ ] Write unit tests for `date-calculation-service`:
  - Future date → positive
  - Today → zero
  - Past date → zero/negative handling
  - Leap year edge cases
  - Week boundary edge cases (respecting `firstWeekday`)

#### Step 1B — State Layer (after 1A)
- [ ] Implement `days-left-state` (`@Observable`, `@MainActor`):
  - Properties: `currentDateInfo: date-info`, `displayText: String`
  - Method: `refresh()` → calls `date-calculation-service`, updates state

#### Step 1C — App Shell (after 1B)
- [ ] Implement `days-left-app.swift`:
  - `@main` struct with `MenuBarExtra("Days Left", systemImage: "calendar")`
  - `.menuBarExtraStyle(.window)`
  - Inject `days-left-state` via `.environment()`
- [ ] Wire menu bar label to `days-left-state.displayText`

#### Sequential
- [ ] Run unit tests: all `date-calculation-service` tests must pass
- [ ] Run app: verify menu bar shows correct days remaining

**CP-1:** `git add . && git commit -m "feat: core date logic, menu bar display, unit tests"`

---

### Phase 2 — Popover Dropdown & Preferences
**Goal:** Clicking the menu bar opens a dropdown with year/month/week breakdown + Preferences/Quit.
**Estimated Effort:** 2-3 hours
**Depends on:** Phase 1

#### Parallel Group 2A — Popover UI
- [ ] Implement `popover-view`:
  - Display: "X days left in the year"
  - Display: "Y days left in the month"
  - Display: "Z days left in the week"
  - Divider line
  - "Preferences" button → opens settings-view
  - "Quit" button → `NSApp.terminate(nil)`
- [ ] Style: system font, calm, no colors, no animations

#### Parallel Group 2B — Preferences
- [ ] Implement `app-settings`:
  - For v1, use direct `@AppStorage`: `@AppStorage("launchAtLogin") var launchAtLogin: Bool = true`
  - Refactor to Codable struct only when v2 adds more settings (YAGNI)
- [ ] Implement `launch-at-login-service`:
  - `enable()` → `SMAppService.mainApp.register()`
  - `disable()` → `SMAppService.mainApp.unregister()`
  - Handle errors gracefully (log + ignore for v1)
  - **Note:** `SMAppService` requires code signing to work. Test after signing is configured.
- [ ] Implement `settings-view`:
  - Launch at Login toggle
  - Bound to `@AppStorage("launchAtLogin")`
  - Toggle triggers `launch-at-login-service`

#### Sequential
- [ ] Wire popover to `days-left-state` for live data
- [ ] Constrain popover width: `.frame(width: 240)` to prevent awkward auto-sizing
- [ ] Verify click-outside-dismissal works (SwiftUI handles this for `MenuBarExtra(.window)`)
- [ ] Test: click menu bar → popover opens → shows correct data
- [ ] Test: toggle Launch at Login → check System Settings
- [ ] Test: Quit button works

**CP-2:** `git add . && git commit -m "feat: popover dropdown, preferences, launch at login"`

---

### Phase 3 — Midnight Refresh & Sleep/Wake
**Goal:** The display auto-updates at midnight and after sleep/wake.
**Estimated Effort:** 1-2 hours
**Depends on:** Phase 2

#### Parallel Group 3A — Refresh Service
- [ ] Implement `midnight-refresh-service` (class, not struct):
  - Store `AnyCancellable` timer subscription as property
  - `start()` → begin `Timer.publish(every: 60, on: .main, in: .common)`
  - `stop()` → cancel timer + remove `NSWorkspace` observer
  - Check if day changed: compare `Calendar.current.component(.day, from: Date())`
  - If day changed → call `days-left-state.refresh()`
- [ ] Handle `NSWorkspace.didWakeNotification` → immediate recalculation

#### Parallel Group 3B — Launch Behavior
- [ ] Detect launch-via-login-item (optional polish):
  - Check `NSAppleEventManager` for `keyAELaunchedAsLogInItem`
  - If launched as login item → don't show popover automatically
- [ ] Ensure launch-at-login preference is respected on first launch
- [ ] Add `NSApplicationDelegateAdaptor` to `days-left-app.swift`:
  - Call `midnight-refresh-service.stop()` on `applicationWillTerminate`
  - Register/deregister `NSWorkspace` observer via delegate

#### Sequential
- [ ] Test: change system date → menu bar updates within 60s
- [ ] Test: sleep/wake → menu bar recalculates immediately
- [ ] Test: let app run past midnight → updates automatically

**CP-3:** `git add . && git commit -m "feat: midnight refresh, sleep/wake handling, launch behavior"`

---

### Phase 4 — Polish, Testing & Distribution Prep
**Goal:** Production-quality build, signed, with test coverage.
**Estimated Effort:** 2-3 hours
**Depends on:** Phase 3

#### Parallel Group 4A — Testing & QA
- [ ] Unit tests: `date-calculation-service` (edge cases, leap years, week boundaries)
- [ ] Unit tests: `app-settings` persistence (verify `@AppStorage` default value and mutation)
- [ ] Manual QA checklist:
  - [ ] Menu bar shows correct number
  - [ ] Popover shows year/month/week
  - [ ] Preferences toggle persists across restarts
  - [ ] Launch at login works
  - [ ] Midnight update works
  - [ ] Sleep/wake update works
  - [ ] Quit works
  - [ ] No Dock icon
  - [ ] No onboarding
  - [ ] No first-launch prompt

#### Parallel Group 4B — Build & Signing
- [ ] Configure two Xcode build configs:
  - `Release` → Developer ID Application (direct distribution)
  - `Release-AppStore` → Apple Distribution (Mac App Store)
- [ ] Enable Hardened Runtime (required for notarization)
- [ ] Configure entitlements (`com.apple.security.app-sandbox` for App Store config)
- [ ] Archive + notarize test build

#### Parallel Group 4C — App Store Assets
- [ ] Create app icon (1024×1024, all sizes in `Assets.xcassets`)
- [ ] Write App Store description (from `mvp-spec.md`)
- [ ] Take screenshots (menu bar, popover, preferences)
- [ ] Prepare keywords, category (Productivity / Utilities)

#### Parallel Group 4D — GitHub Release
- [ ] Create distributable package:
  - Export signed `.app` from Xcode archive
  - Create `.dmg` or `.zip` for distribution
  - Notarize the package (staple ticket for offline install)
- [ ] Write release notes:
  - What's new in v1.0.0
  - System requirements (macOS 13+)
  - Install instructions (drag to Applications)
  - Link to App Store version (if published)
- [ ] Create GitHub Release:
  - Target: `v1.0.0` tag
  - Attach `.dmg` or `.zip` as release asset
  - Mark as "Latest release"
  - Add release notes

#### Sequential
- [ ] Final build verification: clean, archive, no warnings
- [ ] Tag release: `git tag -a v1.0.0 -m "Days Left v1.0.0 — initial release"`
- [ ] Push tag to GitHub: `git push origin v1.0.0`
- [ ] Publish GitHub Release (make public)

**CP-4:** `git add . && git commit -m "release: v1.0.0 distribution build, tests, assets"`
**CP-FINAL:** `git tag v1.0.0 && git push origin v1.0.0`

---

## 5. Parallel Task Execution Strategy

### What Can Run in Parallel (Within a Phase)

| Phase | Parallel Groups |
|-------|----------------|
| **0** | 0A (Xcode setup) + 0B (folders/git) |
| **1** | Sequential: 1A → 1B → 1C (hard dependencies) |
| **2** | 2A (popover UI) + 2B (preferences + login service) |
| **3** | 3A (refresh service) + 3B (launch behavior) |
| **4** | 4A (tests + QA) + 4B (build/signing) + 4C (App Store assets) + 4D (GitHub release) |

### Critical Path

The critical path (longest sequential chain) is:

```
Phase 0 (scaffold) → Phase 1 (core logic) → Phase 2 (UI) → Phase 3 (refresh) → Phase 4 (polish)
```

**Total estimated effort:** ~9-14 hours solo.
**With 2 developers:** ~5-7 hours wall-clock (Phase 1 is sequential, limiting parallelism).

---

## 6. Git Commit Checkpoints (Summary)

| Checkpoint | Phase | Commit Message |
|------------|-------|----------------|
| **CP-0** | Phase 0 | `feat: scaffold days-left xcode project with layered architecture folders` |
| **CP-1** | Phase 1 | `feat: core date logic, menu bar display, unit tests` |
| **CP-2** | Phase 2 | `feat: popover dropdown, preferences, launch at login` |
| **CP-3** | Phase 3 | `feat: midnight refresh, sleep/wake handling, launch behavior` |
| **CP-4** | Phase 4 | `release: v1.0.0 distribution build, tests, assets` |
| **CP-FINAL** | — | `git tag v1.0.0 && git push origin v1.0.0` |

### Commit Hygiene

- **Atomic commits:** Each checkpoint is a single logical unit. If a phase has parallel work, merge all sub-branches before the checkpoint commit.
- **Conventional commits:** `feat:`, `test:`, `fix:`, `release:` prefixes.
- **No WIP commits on main:** Use feature branches for parallel work, merge via PR or `git merge --no-ff`.
- **Tag releases:** Every distribution build gets a semver tag.

---

## 7. Risk Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| `MenuBarExtra(.window)` sizing issues | Low | Medium | Test early in Phase 1. Fallback: AppKit `NSStatusItem` + `NSPopover` (adds ~2h). |
| `SMAppService` fails on user's machine | Medium | Low | Wrap in do-catch, log error, don't crash. User can toggle manually in System Settings. |
| Midnight refresh misses during sleep | Low | High | `NSWorkspace.didWakeNotification` is mandatory (Phase 3). Test via `pmset sleepnow`. |
| App Store rejection (LSUIElement) | Low | Medium | Many apps use this (Bartender, iStats). BuildBar passed review. Have direct distribution fallback. |
| Date math edge cases (leap years, week boundaries) | Medium | Medium | Unit tests in Phase 1. Test with `DateComponents` for known edge cases. |
| Swift 6 strict concurrency warnings | Medium | Low | Use `@MainActor` on all UI-facing classes. Mark service methods `nonisolated` where safe. |

---

## 8. v1 → v2 Bridge (Not Now, Documented)

These features are explicitly out of scope for v1 but the architecture supports them:

| Feature | Where It Would Plug In | Effort Estimate |
|---------|----------------------|-----------------|
| macOS Widget | New `widget/` module + `WidgetKit` | +2h |
| Quarter view in dropdown | Add to `date-calculation-service` + `popover-view` | +30min |
| Year-end "Wrapped" card | New `views/wrapped-view.swift` + share sheet | +4h |
| Goal tracking | New `models/goal.swift` + `services/goal-service.swift` | +6h |
| Apple Watch companion | New Watch app target | +4h |
| Fiscal year support | Add to `app-settings` + `date-calculation-service` | +1h |

The layered architecture keeps these isolated — no v2 feature requires rewriting v1 code.

---

## 9. Quick Reference: Key APIs

### Menu Bar Extra (Phase 1)
```swift
@main
struct days-left-app: App {
    @State private var state = days-left-state()

    var body: some Scene {
        MenuBarExtra("Days Left", systemImage: "calendar") {
            popover-view()
                .environment(state)
        }
        .menuBarExtraStyle(.window)
    }
}
```

### Launch at Login (Phase 2)
```swift
import ServiceManagement

try SMAppService.mainApp.register()   // Enable
try SMAppService.mainApp.unregister() // Disable
```

### Midnight Refresh (Phase 3)
```swift
Timer.publish(every: 60, on: .main, in: .common)
    .sink { _ in checkIfDayChanged() }

NSWorkspace.shared.notificationCenter
    .addObserver(forName: .didWakeNotification, object: nil, queue: .main) { _ in
        recalculate()
    }
```

### @AppStorage Direct Bool (Phase 2 — v1)
```swift
// For v1 with a single preference, use direct @AppStorage:
@AppStorage("launchAtLogin") var launchAtLogin: Bool = true

// When v2 adds more settings, refactor to Codable struct:
// struct AppSettings: Codable, RawRepresentable { ... }
// @AppStorage("settings") var settings = AppSettings()
```

---

*Plan generated from parallel research across 4 agents + direct tools.*
*References: BuildBar, UpNext, TomoBar, Kyan Bar, Barmaid, Xcode Menu Bar Template, Apple Developer Documentation.*
