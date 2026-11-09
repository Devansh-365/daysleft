<p align="center">
  <img src="docs/assets/cover-dark.png" width="100%" alt="Days Left, a macOS menu bar app. The menu bar shows 53d next to the clock. Its dropdown reads 53 days left in the year, 53 in the quarter, 22 in the month and 6 in the week, with Preferences (⌘,) and Quit Days Left (⌘Q).">
</p>

<h3 align="center">Know how much of the year is left without opening a calendar.</h3>

<p align="center">
  One number sits next to your clock. Click it for the quarter, month and week.
</p>

<p align="center">
  <a href="../../releases/latest"><img src="https://img.shields.io/badge/Download_for_macOS-0066cc?style=for-the-badge&logo=apple&logoColor=white" alt="Download for macOS"></a>
</p>

<p align="center">
  <img alt="macOS 13 or later" src="https://img.shields.io/badge/macOS-13%2B-303336?style=flat-square&logo=apple&logoColor=white">
  <img alt="Universal: Apple Silicon and Intel" src="https://img.shields.io/badge/universal-Apple_Silicon_%2B_Intel-0066cc?style=flat-square">
  <img alt="Built with SwiftUI" src="https://img.shields.io/badge/SwiftUI-F05138?style=flat-square&logo=swift&logoColor=white">
  <a href="LICENSE"><img alt="MIT license" src="https://img.shields.io/badge/license-MIT-1f9a4b?style=flat-square"></a>
</p>

<p align="center">
  <a href="#-install"><strong>Install</strong></a> ·
  <a href="#%EF%B8%8F-make-it-yours"><strong>Settings</strong></a> ·
  <a href="#-good-to-know"><strong>Good to know</strong></a> ·
  <a href="#%EF%B8%8F-development"><strong>Development</strong></a>
</p>

## 📅 What it shows

| Where | On Mon 9 Nov 2026 |
|---|---|
| Menu bar | `53d` |
| Year | 53 days left in the year |
| Quarter | 53 days left in the quarter |
| Month | 22 days left in the month |
| Week | 6 days left in the week |

Every count includes today, so the last day of a month reads **1 day left**, and on Dec 31 the year, quarter and month all read 1.

## ⚡ Install

**Let your coding agent do it.** Paste this into Claude Code, Codex, Cursor or Gemini CLI:

```text
Install the latest Days Left release by following https://github.com/Devansh-365/daysleft/blob/main/skills/install-days-left/SKILL.md
```

**Or do it yourself:**

1. Download `DaysLeft-v1.1.0.dmg` from the [latest release](../../releases/latest).
2. Open it and drag **Days Left** into Applications.
3. Launch it. If macOS blocks it, right-click the app and choose **Open**. The app isn't notarized yet.

Terminal commands, checksum checks, building from source and uninstalling are in [docs/install.md](docs/install.md).

## 🎛️ Make it yours

<img align="right" width="360" src="docs/assets/settings-dark.png" alt="Days Left Settings window. Show as offers 53d, 53 days or 53, with the note that VoiceOver always reads the full sentence. Below it, a Launch at login switch, turned off.">

Open **Preferences…** from the dropdown, or press **⌘,**.

- **Show as** `53d`, `53 days` or just `53`.
- **Launch at login** is off until you switch it on. The app never adds itself.
- **⌘Q** quits, and **⌘W** closes the Settings window.

<br clear="right">

## 💡 Good to know

- **Updates on its own** at midnight, after sleep, and when the clock or time zone changes.
- **VoiceOver** reads the menu bar item as "53 days left in the year".
- **Stays out of the way.** It has no Dock icon, sends no notifications and makes no network requests.

## 🛠️ Development

```bash
make build   # debug build
make test    # unit tests
make dmg     # universal, signed DMG for a release
```

The code is split into `app/`, `state/`, `views/`, `services/`, `models/` and `utilities/`. Release notes are in [CHANGELOG.md](CHANGELOG.md), and [CONTRIBUTING.md](CONTRIBUTING.md) explains how to send a change.

## 📄 License

[MIT](LICENSE), by Devansh Tiwari.

<p align="center">
  <sub>If it saves you a trip to the calendar, a ⭐ helps other people find it.</sub>
</p>
