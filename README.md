# Peony - Mindful Journaling iOS App

A beautiful iOS journaling app that combines mindfulness with gamification. Write journal entries that grow into flowers through consistent care and reflection.

**Status:** Active Development  
**Version:** 2.6.0  
**Platform:** iOS 16.0+  
**Language:** Swift 5.9 / SwiftUI

---

## Overview

Peony transforms journaling into a garden-growing experience. Users plant seeds (journal entries), water them daily, and watch them grow through five stages before the content is revealed. The app also includes a Journal mode for quick note-taking with AI-powered features.

---

## Core Features

### Garden Mode
Plant a seed by writing a journal entry. The content is hidden until the seed grows to 100%. Water the seed daily to increase growth rate and build streaks. Seeds grow through five stages: Seed, Sprout, Stem, Bud, and Flower.

### Journal Mode  
Quick access notes for instant capture. Features include:
- Free write or daily prompts
- On-device mood detection
- Theme analysis
- Smart seed suggestions (convert worthy notes to plants)

### Growth Mechanics
- Natural growth over time based on planted duration
- Daily watering increases growth percentage
- Streak system with tiered bonuses (higher multipliers at 7, 14, 30+ days)
- Content locked until full bloom for delayed gratification

### Visual Experience
- Time-aware sky system with real sun/moon positions
- Seasonal color palettes (spring, summer, fall, winter)
- Custom plant growth animations
- Ambient lighting effects
- Custom serif typography (Playfair Display)

---

## Architecture

### Tech Stack
- **UI Framework:** SwiftUI (iOS 16.0+)
- **Data Persistence:** SwiftData
- **AI Processing:** NaturalLanguage framework (on-device)
- **Notifications:** UserNotifications framework
- **Typography:** Playfair Display (serif) and SF Pro (sans)
- **Architecture:** MVVM with component-based structure

### Key Models
- `JournalSeed` - Main seed/entry model with growth tracking
- `JournalEntry` - Quick notes model for Journal tab
- `WateringStreak` - Streak tracking with tiered bonuses
- `WritingPrompt` - Daily prompt data (JSON)

---

## Development

### Setup
1. Clone the repository
2. Open `Peony.xcodeproj` in Xcode 15.0+
3. Select target device/simulator
4. Build and run (Cmd+R)

### Testing
- 480+ lines of unit tests in `PeonyTests.swift`
- Tests cover growth calculations, streak mechanics, edge cases
- Use Testing framework (Swift 5.9)

### Configuration
Key settings in `AppConfig.swift`:
- Growth duration: 30-365 days (default 45)
- Streak tier multipliers: 1.0x (1-6 days), 1.5x (7-29 days), 2.0x (30+ days)
- Notification defaults: 9 AM daily watering reminder
- Minimum seed suggestion: 150 words

### AI Features
All AI features run on-device using NaturalLanguage framework:
- Mood detection from journal text
- Theme analysis for patterns
- Writing prompt generation
- Seed suggestions based on length and sentiment

---

## Recent Updates

### v2.6.0 - October 2024 (Current)
- Data export functionality (JSON format)
- Database error handling and recovery
- Accessibility improvements (labels throughout)
- Dynamic Type support for serif fonts
- SwiftData concurrency fixes
- Removed rain droplets animation (simplified)
- Added comprehensive unit tests

### Architecture Refactor
- Extracted 37 components from monolithic files
- ContentView reduced from 2,755 lines to 120 lines
- Proper separation: Components, Views, Utilities, Models
- Clean modular structure for maintainability

---

## Design System

### Colors
- Backgrounds: Ivory, Pastel Green, Forest tones
- Accents: Warm Gold, Amber Glow
- Plants: Seed Brown, Sprout Green, Bud Pink, Flower Pink

### Typography
- Headlines: Playfair Display (serif)
- Body: SF Pro (sans-serif)

### Animations
- Plant growth stage transitions
- Watering success feedback
- Planting success celebration
- Tab navigation transitions

---

## Documentation

- [`.github/FEATURE_BRANCH_WORKFLOW.md`](.github/FEATURE_BRANCH_WORKFLOW.md) - Development workflow
- [`.cursor/rules/architecture-rules.mdc`](.cursor/rules/architecture-rules.mdc) - Architecture guidelines
- [`.cursor/commands/de-slop.md`](.cursor/commands/de-slop.md) - Code cleanup process

---

## Principles

- **Privacy-first:** All AI runs on-device using NaturalLanguage
- **Intentional design:** Beautiful, meaningful interfaces
- **Mindful gamification:** Focus on habit-building, not addiction
- **Clean code:** Modular architecture, maintainable structure
- **No emojis in documentation or GitHub content**

---

## License

Private project - All rights reserved

**Author:** [@ksemaj](https://github.com/ksemaj)  
**Last Updated:** October 28, 2025
