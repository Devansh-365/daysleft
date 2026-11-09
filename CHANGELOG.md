# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-11-09

### Added
- Quarter row in the dropdown ("N days left in the quarter")
- Menu bar format option in Settings: `53d`, `53 days` or `53`
- Keyboard shortcuts: ⌘, opens Settings, ⌘Q quits, ⌘W closes Settings
- Hover highlight on dropdown items (instant when Reduce Motion is on)
- VoiceOver reads the menu bar item as "N days left in the year"

### Changed
- Every count now includes today, so the last day of a period shows 1 and the rows always agree (on Dec 31 the year, quarter and month all read 1)
- Correct singular/plural wording ("1 day", not "1 days")
- Settings opens as a single window that always comes to the front
- Launch at login now shows the real macOS status, never turns itself on, and offers to open Login Items when macOS needs approval
- The display refreshes on day change, clock change, time zone change and wake from sleep
- The app bundle in the DMG is now signed (ad-hoc)

### Fixed
- Month and week showed 0 on their last day while the year showed 1
- Clicking Preferences repeatedly opened duplicate windows, sometimes behind other apps
- The launch at login toggle could show ON while nothing was registered

## [1.0.0] - 2025-05-13

### Added
- Initial release of Days Left
- Menu bar display showing days remaining in the year
- Click menu bar icon to see year, month, and week breakdown
- Launch at login support via system preferences
- Automatic midnight refresh
- Sleep/wake detection for immediate updates
- Unit tests for date calculation logic

### Technical
- Swift 6 with strict concurrency
- SwiftUI MenuBarExtra with .window style
- Layered architecture: Presentation → State → Services → Models
- Zero third-party dependencies
- macOS 13 Ventura minimum

## [Unreleased]

### Planned
- macOS Widget for Notification Center
- Year-end "Wrapped" summary card
- Fiscal year support
