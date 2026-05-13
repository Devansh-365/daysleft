# Days Left

A minimal macOS menu bar utility that shows exactly how many days remain in the year, month, and week.

## Features

- Shows days remaining in the menu bar (e.g., "47d")
- Click to see year, month, and week breakdown
- Launch at login support
- Updates automatically at midnight
- Handles sleep/wake correctly

## Requirements

- macOS 13 Ventura or later

## Architecture

```
app/         Entry point
state/       Observable app state
views/       SwiftUI views
services/    Business logic
models/      Data models
utilities/   Helpers & extensions
resources/   Assets & config
```

## License

MIT
