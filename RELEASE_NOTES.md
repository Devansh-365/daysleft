## Days Left v1.0.0

### What's New

Days Left is a minimal macOS menu bar utility that shows exactly how many days remain in the year, month, and week.

**Features:**
- Shows days remaining in the menu bar (e.g., "47d")
- Click to see year, month, and week breakdown
- Launch at login support
- Updates automatically at midnight
- Handles sleep/wake correctly

### System Requirements

- macOS 13 Ventura or later
- Apple Silicon or Intel Mac

### Install Instructions

**Option 1: Build from Source (Recommended for now)**
1. Clone this repo
2. Open Xcode → Create New Project → macOS App
3. Import all Swift files from `app/`, `state/`, `views/`, `services/`, `models/`, `utilities/`
4. Add `ServiceManagement` framework
5. Set bundle identifier and signing team
6. Build and run

**Option 2: Download (Coming Soon)**
- A signed `.app` bundle will be attached here once built and notarized

### Uninstall

1. Quit Days Left (click menu bar icon → Quit)
2. Drag "Days Left" from Applications to Trash

### Notes

- The app requires no special permissions
- No Dock icon — it lives only in the menu bar
- No onboarding or first-launch prompts

### Links

- [Source Code](https://github.com/Devansh-365/macapp)
