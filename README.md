# Peony - Mindful Journaling iOS App

A beautiful iOS journaling app that combines mindfulness with gamification. Write journal entries that grow into flowers through consistent care and reflection.

**Status:** Active Development  
**Latest:** v2.6.0 - October 2024 (Sky System & Visual Enhancements)  
**Platform:** iOS 16.0+  
**Language:** Swift 5.9 / SwiftUI

---

## Core Concept

Peony transforms journaling into a garden-growing experience:

1. **Plant a Seed** - Write a journal entry (content hidden until bloom)
2. **Water Daily** - Return each day to nurture your seed
3. **Watch It Grow** - Seed → Sprout → Stem → Bud → Flower (100%)
4. **Content Revealed** - Read your full entry when the flower blooms
5. **Quick Notes** - Capture thoughts instantly in the Journal tab

### Dual Journaling Modes

- **Garden Mode**: Long-form entries with delayed gratification and growth mechanics
- **Journal Mode**: Quick capture notes with instant access and AI-powered insights

---

## Core Experience

- 5-stage plant growth with daily watering
- Streak system with growth bonuses (3, 7, 14, 30 days)
- Content locked until bloom for delayed gratification
- On-device AI using NaturalLanguage framework for mood detection, theme analysis, and smart suggestions
- Beautiful pastel design with time-aware sky (real sun/moon positions, seasonal colors)
- Custom plant animations with realistic growth stages
- Smart notifications for bloom reminders and daily check-ins
- Attach images to entries

---

## Architecture

### Recent Major Refactor (Oct 2024)

**ContentView.swift**: 2,755 lines → 120 lines (96% reduction!)

Extracted **37 components** into organized structure:

```
Peony/
├── Components/
│   ├── Plants/ (6 files) - Growth stage visualizations
│   ├── Flora/ (7 files) - Decorative elements  
│   └── UI/ (15 files) - Backgrounds, effects, buttons, overlays
├── Views/
│   ├── Garden/ (10 files) - Seed management & layout
│   ├── Notes/ (9 files) - Quick notes & journal
│   ├── Onboarding/ (5 files) - First-time experience
│   └── Shared/ (3 files) - Reusable utilities
├── Models/ (7 files) - SwiftData models & extensions
└── Utilities/
    ├── AI/ (4 files) - Mood, prompts, themes, suggestions
    ├── TimeManager.swift - Real-time day/night and seasonal calculations
    └── AmbientLighting.swift - Dynamic lighting based on time
```

### Tech Stack

- **UI:** SwiftUI (iOS 16.0+)
- **Data:** SwiftData (model persistence)
- **AI:** NaturalLanguage framework (on-device)
- **Notifications:** UserNotifications framework
- **Typography:** Playfair Display (custom serif font)
- **Architecture:** MVVM with component-based structure

---

## App Structure

### Main Tabs
- **Garden Tab**: View seeds, water daily, track growth, plant new seeds
- **Journal Tab**: Quick notes, mood detection, theme analysis, convert to seeds

### Key Screens
- `MainAppView`, `ContentView`, `PlantSeedView`, `SeedDetailView`, `NotesView`, `NoteDetailView`, `OnboardingView`

### Design
- Custom typography: Playfair Display (serif), SF Pro (sans)
- Pastel color palette with time-aware sky
- Plant growth animations and transitions

---

## Key Models

- `JournalSeed` - Main seed/entry model (SwiftData)
- `JournalEntry` - Quick notes model (SwiftData)
- `WateringStreak` - Streak tracking (SwiftData)
- `WritingPrompt` - Prompt data (JSON)

---

## Recent Updates

### v2.6.0 - October 2024 (Latest)
- Visual quality overhaul with time-aware sky system
- Major architecture refactor: 37 components extracted
- ContentView reduced from 2,755 to 120 lines (96% reduction)

### Earlier Versions
- v2.6: Component extraction and code cleanup
- v2.5: AI-powered features (mood detection, theme analysis)
- v2.0: Dual journaling modes (Garden + Journal)
- v1.0: Core garden mechanics

---

## Documentation

- [`docs/`](./docs/) - Active project documentation

---

## Roadmap

**Completed**: Core journaling mechanics, garden visualization, streak system, AI mood detection, quick notes, theme analysis, code refactor

**In Progress**: Data export/backup, iCloud sync prep, additional plant varieties

**Planned**: Garden customization, advanced AI insights, widget support

---

## Development Principles

- Privacy-first (all AI on-device using NaturalLanguage)
- Beautiful, intentional design
- Meaningful gamification (not addictive)
- Mindfulness-focused
- Clean, maintainable code

### README Guidelines
- Only include information that accurately represents the current project
- Remove references to non-existent directories or outdated metrics
- Keep it simple: focus on what exists now, not historical artifacts
- No setup instructions for personal projects
- No references to health scores, audits, or archived documentation unless they currently exist

---

## License

Private project - All rights reserved

**Author**: [@ksemaj](https://github.com/ksemaj)  
**Last Updated**: October 27, 2024
