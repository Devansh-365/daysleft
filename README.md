<div align="center">

<h1>Days Left</h1>

<p>A minimal macOS menu bar utility that shows exactly how many days remain in the year, month, and week.</p>

<p>
  <img src="public/screenshot.jpg" width="680" alt="Days Left app showing days remaining in the menu bar with dropdown breakdown">
</p>

<p>
  <a href="../../releases/latest">
    <img src="https://img.shields.io/badge/Download-Latest_Release-0066cc?style=for-the-badge&logo=apple&logoColor=white" alt="Download Latest Release">
  </a>
  <a href="../../stargazers">
    <img src="https://img.shields.io/github/stars/Devansh-365/macapp?style=for-the-badge&color=f1c40f&logo=github" alt="GitHub Stars">
  </a>
</p>

<p>
  <img src="https://img.shields.io/badge/macOS-13%2B-0066cc?logo=apple&logoColor=white" alt="macOS 13+">
  <img src="https://img.shields.io/badge/Swift-6-orange?logo=swift&logoColor=white" alt="Swift 6">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="MIT License">
</p>

</div>

<br>

## What It Does

Days Left sits quietly in your menu bar and tells you one thing: how many days are left in the year. Click it for the full breakdown (year, month, week). That is it. No notifications. No sounds. No clutter.

**Why use it?**

- **Visual reminder** of time passing. Seeing "232d" every day changes how you think about your week.
- **Minimal** by design. One number in your menu bar. One click for details.
- **Native macOS** app. Built with SwiftUI, not Electron. Uses barely any CPU or memory.

<br>

## Download

<a href="../../releases/latest">
  <img src="https://img.shields.io/badge/Download_Latest_Release-0066cc?style=for-the-badge&logo=apple&logoColor=white" alt="Download Latest Release">
</a>

<br>
<br>

### Install

1. Download `DaysLeft-v1.0.0.dmg` from the latest release
2. Open the DMG
3. Drag **Days Left** to Applications
4. Launch from Applications

**Note:** The app is not signed with an Apple Developer certificate. On first launch, right-click the app and select **Open** to bypass Gatekeeper.

<br>

## Features

| Feature | Description |
|---------|-------------|
| Always Visible | Days remaining shown directly in your menu bar (e.g., "232d") |
| Detailed Breakdown | Click to reveal year, month, and week remaining |
| Auto Refresh | Updates at midnight automatically |
| Sleep Aware | Recalculates immediately after sleep or wake |
| Launch at Login | Optional, enabled by default |
| Zero Distractions | No Dock icon, no notifications, no sounds |

<br>

## Requirements

- macOS 13 Ventura or later
- Apple Silicon or Intel Mac

<br>

## Development

### Build

```bash
make build
```

### Test

```bash
make test
```

### Create Release DMG

```bash
make dmg
```

<br>

## Tech Stack

<p>
  <img src="https://img.shields.io/badge/Swift-6-F05138?logo=swift&logoColor=white&style=flat-square" alt="Swift 6">
  <img src="https://img.shields.io/badge/SwiftUI-0066cc?logo=swift&logoColor=white&style=flat-square" alt="SwiftUI">
  <img src="https://img.shields.io/badge/Xcode-16-147EFB?logo=xcode&logoColor=white&style=flat-square" alt="Xcode 16">
  <img src="https://img.shields.io/badge/macOS-13%2B-0066cc?logo=apple&logoColor=white&style=flat-square" alt="macOS 13+">
</p>

<br>

## Architecture

```
app/         Entry point with MenuBarExtra
state/       Observable app state (days-left-state)
views/       SwiftUI views (popover, settings)
services/    Business logic (date calc, refresh, login)
models/      Data models (date-info)
utilities/   Helpers and formatters
public/      Screenshots and assets
```

<br>

## License

MIT

<br>

<div align="center">

<p>If you find this useful, consider giving it a star. It helps others find it.</p>

<p>
  <a href="../../stargazers">
    <img src="https://img.shields.io/github/stars/Devansh-365/macapp?style=social" alt="Star on GitHub">
  </a>
</p>

</div>
