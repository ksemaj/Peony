# 🌸 Peony - Mindful Journaling iOS App

A beautiful iOS journaling app that combines mindfulness with gamification. Write journal entries that grow into flowers through consistent care and reflection.

**Status:** ✅ Active Development  
**Latest:** v2.6.0 - October 2024 (Sky System & Visual Enhancements)  
**Platform:** iOS 16.0+  
**Language:** Swift 5.9 / SwiftUI  
**Health Score:** 9.0/10

---

## 🌱 Core Concept

Peony transforms journaling into a garden-growing experience:

1. **Plant a Seed** - Write a journal entry (content hidden until bloom)
2. **Water Daily** - Return each day to nurture your seed
3. **Watch It Grow** - Seed → Sprout → Stem → Bud → Flower (100%)
4. **Content Revealed** - Read your full entry when the flower blooms
5. **Quick Notes** - Capture thoughts instantly in the Journal tab

### Dual Journaling Modes

- **🌱 Garden Mode**: Long-form entries with delayed gratification and growth mechanics
- **📔 Journal Mode**: Quick capture notes with instant access and AI-powered insights

---

## ✨ Features

### Gamification
- 🌱 5-stage plant growth (seed → flower)
- 💧 Daily watering mechanic
- 🔥 Streak system with bonuses (3, 7, 14, 30 days)
- 🎯 Delayed gratification (content locked until bloom)
- 📈 Growth stats and tracking

### On-Device AI (Privacy-First)
- 🎭 Mood detection (Natural Language framework)
- 💭 Theme analysis (pattern recognition)
- ✍️ Writing prompts (daily suggestions)
- 🌱 Smart seed suggestions (converts worthy notes)
- 📊 Insights and analytics

### User Experience
- 🎨 Beautiful pastel design with custom serif typography
- 🌅 Dynamic time-aware sky (real sun/moon positions, seasonal colors)
- 🌸 Custom plant animations with realistic growth stages
- 📱 Native iOS with SwiftUI
- 🔔 Smart notifications (bloom reminders, daily check-ins)
- 📸 Attach images to entries
- 🦋 Time-aware fauna (butterflies during day, fireflies at night)

---

## 🏗️ Architecture

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

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 16.0+ device or simulator
- macOS Ventura or later

### Setup

1. **Clone the repository**
```bash
git clone https://github.com/ksemaj/Peony.git
cd Peony
```

2. **Open in Xcode**
```bash
open Peony.xcodeproj
```

3. **Build and Run**
- Select target device/simulator
- Press `Cmd + R` or click ▶️ Play button

### First Launch

1. Complete onboarding (3 slides)
2. Enable AI features (optional but recommended)
3. Set notification preferences
4. Plant your first seed or write a quick note!

---

## 📱 App Structure

### Main Tabs

**🌱 Garden Tab**
- View all planted seeds in garden beds
- Tap seeds to view details and water
- Growth progress visualization
- Plant new seeds with + button

**📔 Journal Tab**
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

## 🎨 Design System

### Colors
- **Backgrounds:** Ivory, Pastel Green, Forest tones
- **Accents:** Warm Gold, Amber Glow
- **Plants:** Seed Brown, Sprout Green, Bud Pink, Flower Pink
- **UI:** Card Light, Soft Gray, Cream Text

### Typography
- **Serif:** Playfair Display (headlines, emphasis)
- **Sans:** SF Pro (system default, body text)

### Animations
- Plant growth transitions
- Watering success feedback
- Planting success celebration
- Subtle UI interactions

---

## 🔧 Configuration

### AI Features (`AppConfig.AI`)
```swift
- moodDetectionEnabled: Bool (default: true)
- seedSuggestionsEnabled: Bool (default: true)
- writingPromptsEnabled: Bool (default: true)
- themeAnalysisEnabled: Bool (default: true)
```

### Growth Settings (`AppConfig.Growth`)
```swift
- baseDaysToBloom: Int (default: 14)
- wateringGrowthPercentage: Double (default: 5.0)
```

### Streak Bonuses (`AppConfig.Streak`)
```swift
- day3Bonus: 0.5% additional growth
- day7Bonus: 1.0% additional growth
- day14Bonus: 2.0% additional growth
- day30Bonus: 3.0% additional growth
```

---

## 🧪 Development

### Testing Shortcuts

**Toolbar Buttons** (visible in Garden tab):
- `?` - Help/Onboarding
- 🔔 - Test notifications
- `+` - Plant new seed

### Debug Mode

Enable AI feature logs:
```swift
// Check console for mood detection output
print("🎭 MoodDetector: ...")
print("🌱 SeedSuggestionEngine: ...")
print("📝 PromptGenerator: ...")
```

### Key Models

- `JournalSeed` - Main seed/entry model (SwiftData)
- `JournalEntry` - Quick notes model (SwiftData)
- `WateringStreak` - Streak tracking (SwiftData)
- `WritingPrompt` - Prompt data (JSON)

---

## 📊 Version History

### v2.6.0 - October 2024 ✅ (Latest)
- **Visual Quality Overhaul**: Eliminated all frosted/white effects
- **Time-Aware Sky System**: Real sun/moon positions, seasonal colors
- **New Utilities**: TimeManager and AmbientLighting systems
- **Enhanced Components**: 14 files updated for dynamic behavior
- **Pure Colors**: No white tinting, rich atmospheric visuals
- **Repository Organization**: Clean structure with organized docs
- Health Score: 9.0/10

### v2.6 - October 2024 ✅
- **Major Refactor**: 37 components extracted
- ContentView reduced 96% (2,755 → 120 lines)
- Code deduplication complete
- AI bug fixes applied
- Garden UI cleaned up
- All features working

### v2.5 - Prior
- AI-powered seed suggestions
- Mood detection on notes
- Theme analysis
- Enhanced notifications

### v2.0 - Quick Notes
- Dual journaling modes
- Journal tab with instant access
- "Free Write" and "Today's Prompt" options

### v1.0 - Initial
- Core garden mechanics
- Seed planting and watering
- Basic growth system
- Streak tracking

---

## 📖 Documentation

### Documentation
- **Main README** - Project overview and architecture
- **GitHub Issues** - Current development work and tracking
- **Critical Issues** - See [`ISSUES_TO_CREATE.md`](./ISSUES_TO_CREATE.md) for items from recent audit

### Recent Updates
- ✅ Repository audit and cleanup (Oct 2025)
- ✅ Architecture rules aligned and simplified
- ✅ Removed outdated documentation and archives
- ✅ Consolidated all documentation into this README

---

## 🎯 Roadmap

### Completed ✅
- ✅ Core journaling mechanics
- ✅ Garden visualization
- ✅ Streak system
- ✅ AI mood detection
- ✅ Quick notes mode
- ✅ Theme analysis
- ✅ Code architecture refactor

### In Progress 🚧
- Data export/backup functionality
- iCloud sync preparation
- Additional plant varieties

### Planned 📅
- Garden customization
- Advanced AI insights
- Social features (optional)
- Widget support
- Premium features (future consideration)

---

## 🤝 Contributing

This is a personal project, but suggestions and feedback are welcome!

### Development Principles
- Privacy-first (all AI on-device)
- Beautiful, intentional design
- Meaningful gamification (not addictive)
- Mindfulness-focused
- Clean, maintainable code

---

## 📄 License

Private project - All rights reserved

---

## 👤 Author

**James** - [@ksemaj](https://github.com/ksemaj)

---

## 🙏 Acknowledgments

- Custom typography: Playfair Display font
- Inspiration: Mindfulness practices and nature
- Framework: SwiftUI and Apple's developer tools

---

**Last Updated:** October 2025  
**Build Status:** ✅ Working  
**Refactor Status:** ✅ Complete
