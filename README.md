# Days Left

A minimal macOS menu bar utility that shows exactly how many days remain in the year, month, and week.

## Features

- **Menu Bar Display** — Shows days remaining in the year (e.g., "47d")
- **Dropdown Breakdown** — Click to see year, month, and week remaining
- **Launch at Login** — Optional, enabled by default
- **Auto Refresh** — Updates at midnight automatically
- **Sleep Aware** — Recalculates immediately after sleep/wake
- **Zero Distractions** — No Dock icon, no notifications, no sounds

## Download

Download the latest version from the [Releases](../../releases) page.

### Install

1. Download `DaysLeft-v1.0.0.dmg`
2. Open the DMG
3. Drag "Days Left" to Applications
4. Launch from Applications

## Requirements

- macOS 13 Ventura or later
- Apple Silicon or Intel Mac

## Development

### Prerequisites

- Xcode 16 or later
- macOS 13.0 SDK

### Build

```bash
make build
```

### Test

```bash
make test
```

### Release

```bash
make release
```

## Architecture

```
app/         Entry point with MenuBarExtra
state/       Observable app state (days-left-state)
views/       SwiftUI views (popover, settings)
services/    Business logic (date calc, refresh, login)
models/      Data models (date-info)
utilities/   Helpers & formatters
resources/   Assets & config
```

## Tech Stack

- Swift 6 with strict concurrency
- SwiftUI MenuBarExtra
- @Observable for state management
- SMAppService for launch at login
- Timer + NSWorkspace for refresh
- XCTest for unit testing

## License

MIT

## Acknowledgments

- Inspired by Sindre Sorhus's menu bar utilities
- Architecture references: BuildBar, UpNext
