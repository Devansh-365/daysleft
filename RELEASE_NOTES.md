## Days Left v1.1.0

The numbers now always agree, the dropdown feels like a native Mac menu, and VoiceOver users hear a real sentence.

### What's new

- **Quarter row.** See how many days are left in the current quarter.
- **Choose how the menu bar looks.** `53d`, `53 days` or `53`, in Settings.
- **Keyboard shortcuts.** ⌘, opens Settings, ⌘Q quits, ⌘W closes Settings.
- **Hover highlight** on Preferences and Quit.
- **VoiceOver** reads the menu bar item as "53 days left in the year" instead of "53 d".

### Fixes

- **Counts are consistent.** Every count includes today, so the last day of a month shows 1, not 0. On Dec 31 the year, quarter and month all read 1.
- **Correct wording.** "1 day left", not "1 days left".
- **One Settings window.** It always comes to the front, and clicking Preferences again no longer opens duplicates.
- **Launch at login tells the truth.** The switch shows what macOS actually has. The app never turns it on by itself, so you won't get a "Login item added" alert unless you switch it on.
- **Updates right away** at midnight, after a clock or time zone change, and after waking from sleep.

### Install

1. Download `DaysLeft-v1.1.0.dmg` below
2. Open it and drag **Days Left** into Applications
3. If an older version is running, quit it first (click the menu bar number → Quit)
4. Launch Days Left from Applications

**First launch:** the app is not notarized by Apple yet. If macOS blocks it, right-click the app in Applications and choose **Open**.

**Launch at login** is off until you turn it on in Settings (⌘, from the dropdown).

### System requirements

- macOS 13 Ventura or later
- Apple Silicon or Intel Mac (universal app)

### Uninstall

1. Quit Days Left (click the menu bar number → Quit, or ⌘Q)
2. Drag **Days Left** from Applications to the Trash

### Links

- [Source code](https://github.com/Devansh-365/daysleft)
- [Changelog](https://github.com/Devansh-365/daysleft/blob/main/CHANGELOG.md)
