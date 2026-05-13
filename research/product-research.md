# Phase 1 Research — Year Remaining Mac App

## Product Concept
A Mac menu bar app that shows exactly how much time remains in the year. Core emotion: urgency through time scarcity. Not "how much has passed" — but "how much is left."

---

## Problem Statement

High-performers on Mac have no persistent, concrete signal that the year is running out. The year slips by invisibly — no ambient reminder, no concrete number. The real competitor is not another app. It's the absence of awareness.

A single visible number ("47 days left") becomes a daily decision filter: *is this how I want to spend one of my 47 days?*

**Pain:** Daily ambient — every glance at the Mac, the year is slipping without a number to anchor it.
**Fear:** Unfinished yearly goals + the identity gap between who they are and who they planned to be.
**Workaround:** Nothing. People drift, then panic in December.
**Success in 30 days:** The user makes better daily decisions about where their time goes — not through task tracking, but through a single number that changes what they notice.

---

## Target User

Already productive. Already pays for quality Mac tools (Things 3, Raycast, CleanShot). Doesn't need fixing — needs sharper time awareness. Age 25–40. The Sindre Sorhus customer.

---

## Core Product Decisions

| Decision | Choice | Reason |
|---|---|---|
| Primary menu bar display | Days remaining ("47 days") | Days are concrete. Percentages are abstract. Loss aversion works better with real units. |
| Dropdown content | Year + month + week stacked | Cascading urgency. Week-level changes today's behavior. Year-level is the emotional anchor. |
| Visual style | Calm — no color changes, no alarms | The number speaks for itself. Color changes feel like judgment. Trust = daily use. |
| v1 pricing | Free | Maximize reach for v1. |

---

## Competitive Landscape

### Mac App Store
| App | Price | Rating | Reviews | Key Weakness |
|---|---|---|---|---|
| Progress Bar OSX (Andrii Azimov) | $9.99 | — | ~0 | Shows elapsed %, not remaining; $9.99 draws complaints; website 403 |
| Day Progress (Sindre Sorhus) | $4.00 | 4.0 | Low | DAY only — no year progress at all |
| Year Progress: Life in Motion | Free + IAP | 4.8 | 5 | Tiny user base; ads in free tier |
| Year Progress: Widget | Free + IAP | 5.0 | 2 | Essentially no market presence |
| One Year Progress | $0.99 | — | 0 | No menu bar support |

**Key insight:** The highest-rated competitor in this category has 5 reviews. The Mac App Store slot is wide open at the quality level.

### Social Proof (Demand Signals)
- **@year_progress (Twitter/X):** Single tweet "2024 is 50% complete" → 2.5M views, 26K likes, 10K retweets (July 2024)
- **@progressbar_ (Instagram):** 880,000 followers — pure recurring year-progress content, **no premium product attached**
- **Product Hunt:** Year Progress Chrome extension → 220 upvotes, #5 of the day (2018)
- **GitHub:** 10+ repos cloning the concept — developer fascination is high

**The gap:** 880K Instagram followers + 2.5M tweet views = proven massive demand. Zero quality Mac app capturing it.

---

## Psychology Research

| Mechanism | Effect |
|---|---|
| Fresh Start Effect (Dai & Milkman, 2014) | Temporal landmarks drive 354–657% increase in goal engagement |
| Loss Aversion (Kahneman) | "Days remaining" framing hits 2:1 harder than "days elapsed" |
| Goal Gradient Effect | Effort intensifies as deadline approaches — final stretch accelerates motivation |
| Zeigarnik Effect | Incomplete tasks stay mentally "open," creating persistent tension |
| Temporal Scarcity | Brain treats shrinking time as a threat — reduces rational override, increases urgency |
| Mortality Salience | Year as a unit of life makes year-end a mini mortality reminder |

**Key stat:** 91% of people fail their New Year's resolutions. 80% abandon by February. Strava identified January 19th as "Quitter's Day" from 800M+ logged activities. By Q4, users are driven by regret avoidance — not hope. Your app speaks to that second urgency spike.

**Bottom line:** Year-end urgency is not rational. It activates the same brain circuits as physical threat, social exclusion, and story incompleteness — simultaneously. A simple number in the menu bar taps all of it.

---

## What We Will NOT Build (v1)

- Goal tracking / task management
- Social sharing features
- Fiscal year / custom calendar support
- Notifications or nudges
- Android / Windows
- Full-window app

---

## Reference
- Inspiration: [sindresorhus.com/week-number](https://sindresorhus.com/week-number)
- @progressbar_ Instagram: 880K followers, no product
- Sindre's Day Progress: proves the $4 menu bar utility model works; year-progress slot is open
