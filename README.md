# 🌸 Peony 

A beautiful iOS journaling app for mindful reflection. Write journal entries that grow into flowers through consistent care.

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

## Tech Stack

- **UI:** SwiftUI (iOS 16.0+)
- **Data:** SwiftData (model persistence)
- **AI:** NaturalLanguage framework (on-device)
- **Notifications:** UserNotifications framework
- **Typography:** Playfair Display (serif) and SF Pro (sans)
- **Architecture:** MVVM with component-based structure

---

## App Structure

### Main Tabs

**Garden Tab**
- View all planted seeds in garden beds
- Tap seeds to view details and water
- Growth progress visualization
- Plant new seeds with + button

**Journal Tab**
- Quick notes list (instant access)
- Free write or use daily prompts
- Mood detection on entries
- Convert notes to seeds
- Theme analysis & insights

### Key Screens

- `MainAppView` - Tab navigation
- `ContentView` - Garden view (main)
- `PlantSeedView` - Create new seed
- `SeedDetailView` - View/edit/water seeds
- `NotesView` - Journal entry list
- `NoteDetailView` - View/edit notes
- `OnboardingView` - First-time setup

---

## Design

### Colors
- Backgrounds: Ivory, Pastel Green, Forest tones
- Accents: Warm Gold, Amber Glow
- Plants: Seed Brown, Sprout Green, Bud Pink, Flower Pink

### Typography
- Playfair Display (serif) for headlines
- SF Pro (sans) for body text

### Animations
- Plant growth transitions
- Watering success feedback
- Planting success celebration

---

## Key Models

- `JournalSeed` - Main seed/entry model (SwiftData)
- `JournalEntry` - Quick notes model (SwiftData)
- `WateringStreak` - Streak tracking (SwiftData)
- `WritingPrompt` - Prompt data (JSON)

---

## Recent Updates

### v2.6.0 - October 2024 (Latest)
- Data export functionality (JSON format)
- Database error handling and recovery
- Accessibility improvements (labels throughout)
- Dynamic Type support for serif fonts
- SwiftData concurrency fixes
- Removed rain droplets animation (simplified)
- Added comprehensive unit tests

### Earlier Versions
- v2.6: Component extraction and code cleanup
- v2.5: AI-powered features (mood detection, theme analysis)
- v2.0: Dual journaling modes (Garden + Journal)
- v1.0: Core garden mechanics

---

## Development Principles

- Privacy-first (all AI on-device using NaturalLanguage)
- Beautiful, intentional design
- Meaningful gamification
- Mindfulness-focused
- Clean, maintainable code

---

## License

Private project - All rights reserved

**Author**: [@ksemaj](https://github.com/ksemaj)  
**Last Updated**: October 28, 2025
