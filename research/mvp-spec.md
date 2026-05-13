# Days Left — MVP Spec

## App Identity
- **Name:** Days Left
- **Platform:** macOS (menu bar utility)
- **Minimum macOS:** 13 Ventura
- **Price:** Free (v1)
- **App Store Description:** See exactly how many days remain in the year, month, and week — always in your menu bar.

---

## Core Problem
High-performers on Mac have no persistent, concrete signal that the year is running out. The year slips by invisibly. A single number — "47d" — in the menu bar becomes a daily decision filter: *is this how I want to spend one of my 47 days?*

---

## v1 Feature Spec

### Menu Bar
- Displays: `47d` (days remaining in the current year)
- Updates: once per day at midnight
- Style: system font, no color changes, no animations

### Dropdown (click menu bar item)
```
47 days left in the year
11 days left in the month
 2 days left in the week
─────────────────────────
Preferences
Quit
```

### Preferences
- Launch at Login toggle (on by default)
- Nothing else

### Launch Behavior
- Launches at login by default
- No onboarding screen
- No first-launch prompt

---

## Never List (permanent)
- Notifications / push reminders
- Goal tracking / resolution input
- Sounds or haptics
- Fiscal year / custom calendar support
- Social sharing features
- Full-window mode

---

## v2 Candidates (not now)
- macOS Widget (Notification Center)
- Apple Watch companion
- Year-end "Wrapped" summary card
- Quarter view in dropdown

---

## Target User
Already productive Mac user, 25–40, pays for quality tools (Things 3, Raycast, CleanShot). Doesn't need fixing — needs sharper time awareness.

---

## Positioning
The Sindre Sorhus slot for year progress. Calm, focused, does one thing perfectly. The number speaks for itself.
