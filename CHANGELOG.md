# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
- Quarter view in dropdown
- Year-end "Wrapped" summary card
- Fiscal year support
