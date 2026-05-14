<div align="center">

<br>

<h1>Days Left</h1>

<p>Minimal macOS menu bar utility. Know exactly how many days remain in the year, always.</p>

<br>

<img src="public/screenshot.jpg" width="720" alt="Days Left menu bar app showing days remaining with dropdown">

<br>
<br>

<a href="../../releases/latest">
  <img src="https://img.shields.io/badge/Download_for_macOS-0066cc?style=for-the-badge&logo=apple&logoColor=white" alt="Download for macOS">
</a>
&nbsp;
<a href="../../stargazers">
  <img src="https://img.shields.io/badge/Star_on_GitHub-f1c40f?style=for-the-badge&logo=github&logoColor=black" alt="Star on GitHub">
</a>

<br>
<br>

<img src="https://img.shields.io/badge/macOS-13%2B-0066cc?logo=apple&logoColor=white" alt="macOS 13+">
<img src="https://img.shields.io/badge/Swift-6-F05138?logo=swift&logoColor=white" alt="Swift 6">
<img src="https://img.shields.io/badge/SwiftUI-0066cc?logo=swift&logoColor=white" alt="SwiftUI">
<img src="https://img.shields.io/badge/Xcode-16-147EFB?logo=xcode&logoColor=white" alt="Xcode 16">
<img src="https://img.shields.io/badge/License-MIT-green" alt="MIT License">

</div>

<br>
<br>

## The Problem

You open your calendar when you want to know how many days are left in the year. Or month. Or week. That takes clicks, mental math, and interruption. Days Left removes all of that. One number lives in your menu bar. Click it if you want the breakdown.

**What you get:**

- Days left in the year, visible at all times
- Click for month and week breakdown
- Updates automatically at midnight
- Wakes correctly after sleep
- No Dock icon, no notifications, no noise

<br>

## Install

```bash
# Download the latest DMG from releases
# Open it, drag to Applications, launch
```

Or manually:

1. Download `DaysLeft-v1.0.0.dmg` from [latest release](../../releases/latest)
2. Open the DMG
3. Drag **Days Left** into Applications
4. Launch

**First launch:** Right-click the app and select **Open** to bypass Gatekeeper (the app is not yet signed with an Apple Developer certificate).

<br>

## Requirements

- macOS 13 Ventura or later
- Apple Silicon or Intel Mac

<br>

## Development

```bash
make build    # Build the app
make test     # Run unit tests
make dmg      # Create release DMG
```

<br>

## Architecture

| Layer | Responsibility |
|-------|---------------|
| `app/` | Entry point with MenuBarExtra |
| `state/` | Observable app state |
| `views/` | SwiftUI views (popover, settings) |
| `services/` | Date calculation, refresh, launch at login |
| `models/` | Date info data models |
| `utilities/` | Helpers and formatters |
| `public/` | Screenshots and assets |

<br>

## License

MIT

<br>

<div align="center">

<p>Built with SwiftUI for macOS. <a href="../../stargazers">Star this repo</a> if you find it useful.</p>

<br>

<a href="../../releases/latest">Download</a>
&nbsp;|&nbsp;
<a href="../../stargazers">Star</a>
&nbsp;|&nbsp;
<a href="../../issues">Issues</a>
&nbsp;|&nbsp;
<a href="../../blob/main/LICENSE">License</a>

</div>
