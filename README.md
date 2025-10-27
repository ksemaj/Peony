# Peony 🌸

A mindful journaling app where your thoughts grow into beautiful flowers.

## Overview

Peony transforms the journaling experience by gamifying personal growth. Each journal entry is a "seed" that grows over time, blooming into a flower after 45 days. Daily watering creates a habit loop that encourages consistent reflection and speeds up growth.

**New in v2.0:** Quick Notes complement seeds by offering instant journaling for daily thoughts, observations, and reflections. Two modes, one garden.

## Features

### Core Functionality

**Seeds (Deep Journaling):**
- 🌱 **Plant Seeds** - Create journal entries with text and optional images
- 💧 **Daily Watering** - Water your seeds to speed up growth (+1% per day)
- 🌸 **Watch Them Bloom** - Seeds progress through 5 growth stages over 45 days
- 📊 **Track Progress** - Monitor growth percentage for each seed
- 🔥 **Watering Streaks** - Build daily habits with streak multipliers
- ✏️ **Edit & Delete** - Modify or remove seeds at any time

**Quick Notes (Daily Journaling):**
- 📝 **Quick Capture** - Write notes instantly, no growth cycle
- 📅 **Chronological List** - All notes sorted by date
- 🔍 **Preview & Search** - Browse with word count and previews
- ✏️ **Full CRUD** - Create, read, update, delete instantly
- 🎨 **Same Beautiful UI** - Consistent garden-themed design
- 🤖 **AI Features (v2.5)** - Mood detection & writing prompts

**Garden Experience:**
- 🎨 **Beautiful Garden** - Custom-drawn plants, trees, and decorative flora
- 🗂️ **Tab Navigation** - Switch between Garden (seeds) and Notes tabs
- 🔔 **Smart Notifications** - Bloom alerts and optional reminders

### Growth Stages
1. **Seed** (0-24%) - 🌱 Just planted
2. **Sprout** (25-49%) - 🌿 First leaves appear
3. **Growing** (50-74%) - 🪴 Stem develops
4. **Budding** (75-99%) - 🌺 Bud forms
5. **Full Bloom** (100%) - 🌸 Journal entry revealed!

### Unique Mechanics
- **Hidden Content** - Journal entries are hidden until seeds fully bloom at 100%
- **Watering Bonus** - Daily watering adds +1% growth (can reduce 45-day bloom to ~22 days)
- **Custom Art** - Hand-crafted plant illustrations and garden decorations
- **Mindful Design** - Pastel colors, smooth animations, and calming garden atmosphere
- **Delayed Gratification** - Encourages patience and reflection over immediate consumption

## Technical Details

### Requirements
- **iOS:** 17.0+
- **Xcode:** 15.0+
- **Swift:** 5.9+
- **SwiftData** for data persistence

### Architecture

```
Peony/
├── PeonyApp.swift              # App entry point
├── MainAppView.swift           # Tab navigation (Garden + Notes)
├── ContentView.swift           # Garden view (seeds & watering)
├── OnboardingView.swift        # First-time user experience
├── Models/
│   ├── JournalSeed.swift       # Seed data model
│   ├── JournalEntry.swift      # Journal entry model (v2.0, renamed from QuickNote in v2.6)
│   ├── WritingPrompt.swift     # Writing prompt model (v2.5)
│   ├── WateringStreak.swift    # Streak tracking (v1.3.0)
│   ├── GrowthStage.swift       # Growth stage enum
│   ├── ColorExtensions.swift   # Design system colors
│   └── Config.swift            # App configuration
├── Views/
│   ├── Garden/                 # Seed planting views
│   ├── Notes/                  # Quick Notes views (v2.0)
│   │   ├── NotesView.swift
│   │   ├── CreateNoteView.swift
│   │   ├── NoteDetailView.swift
│   │   ├── EditNoteView.swift
│   │   └── NoteRowView.swift
│   └── Shared/                 # Shared components
├── Utilities/
│   ├── NotificationManager.swift  # Notification system
│   ├── ExportManager.swift        # Export utilities
│   └── AI/                        # AI features (v2.5)
│       ├── MoodDetector.swift     # Sentiment analysis
│       └── PromptGenerator.swift  # Writing prompts
└── Components/                 # Custom UI components (in ContentView)
    ├── Flora/                  # Decorative plants (trees, bushes, etc.)
    ├── Plants/                 # Growth stage visualizations
    └── UI/                     # Reusable UI elements
```

### Design Patterns
- **SwiftUI + SwiftData** - Modern Apple frameworks for UI and persistence
- **Computed Properties** - For derived values (growth %, stage, watering eligibility)
- **Custom Components** - Hand-drawn plant and flora views
- **Single View Architecture** - All UI consolidated in ContentView for simplicity

## Setup Instructions

### 1. Clone Repository
```bash
git clone <repository-url>
cd Peony
```

### 2. Open in Xcode
```bash
open Peony.xcodeproj
```

### 3. Add New Files to Project (If Needed)
If new model files aren't in the Xcode project:
1. Right-click "Peony" folder in Project Navigator
2. Select "Add Files to 'Peony'..."
3. Navigate to `Peony/Models/` and add all `.swift` files
4. Ensure "Create groups" is selected
5. Uncheck "Copy items if needed"

### 4. Build and Run
```bash
# Command line
xcodebuild -scheme Peony -destination 'platform=iOS Simulator,name=iPhone 15'

# Or press Cmd+R in Xcode
```

## Development Phases

### ✅ v1.0.0 - Core Experience (Completed)
- Journal entries as growing seeds
- 5-stage growth visualization
- Daily watering mechanic
- Edit & delete functionality
- Beautiful garden layout

### ✅ v1.1.0 - Technical Cleanup (Completed)
- Extracted models to separate files
- Organized folder structure
- Centralized configuration
- Added export and settings features

### ✅ v1.2.0 - Soft Reset (Completed)
**Back to core - removed complexity:**
- Changed growth period: 90 days → 45 days
- Removed search & filtering
- Removed export system
- Removed settings menu
- Removed notifications
- Focus on essential seed-planting experience

### ✅ v1.3.0 - Core Refinement (Completed)
**Performance & engagement improvements:**
- 🎨 Animation optimizations for smooth 60fps experience
- 🔥 Watering streak system with tiered multipliers (Day 1-6: +1.0%, Day 7-29: +1.5%, Day 30+: +2.0%)
- 💧 Enhanced watering animations with visual feedback
- 🎉 Celebration overlays for streaks and milestones
- 🔔 Redesigned notification system (bloom alerts, daily reminders, weekly check-ins)
- ⚙️ Notification settings view for user preferences

### ✅ v1.3.1 - Onboarding Enhancement (Completed)
**Improved first-time user experience:**
- 🔔 Integrated notification setup into onboarding flow
- 📱 New notification setup page with clear UI (page 3 of 4)
- 🗑️ Removed separate settings menu (will return with more options later)
- ✨ Better readability with proper text contrast throughout
- 📈 Higher notification opt-in rates with contextual setup

### ✅ v2.0.0 - Quick Notes (COMPLETE)
**Dual journaling modes:**
- 📝 Quick Notes feature for daily journaling
- 🗂️ Tab navigation between Garden (seeds) and Notes
- ✏️ Full CRUD operations (create, read, update, delete)
- 🔍 Search functionality with time filters
- 📊 Statistics view with writing insights
- 🎨 Consistent garden-themed UI design
- ✨ Smooth animations and haptic feedback
- 🔮 Future-ready for AI mood detection

**All Phases Complete:**
- ✅ Phase 2.1: QuickNote data model, tab navigation, CRUD views
- ✅ Phase 2.2: Animations, transitions, haptic feedback
- ✅ Phase 2.3: Search by content, time filters (All/Week/Month)
- ✅ Phase 2.4: Statistics view (total notes, word counts, trends)

### ✅ v2.5.1 - On-Device AI Features (COMPLETE)
**Intelligent journaling with complete privacy:**
- ✅ **Week 1: Mood Detection** - Auto-detect mood using NaturalLanguage framework
  - Sentiment analysis on all notes
  - Mood filter chips (joyful, grateful, reflective, thoughtful, peaceful)
  - Works completely offline, 100% private
- ✅ **Week 2: Writing Prompts** - Daily inspiration to write
  - 60 curated prompts across 6 categories
  - Smart rotation (time-aware, no repeats)
  - One-tap note creation from prompts
  - Skip functionality for new prompt
- ✅ **Week 3: Pattern Recognition** - Extract recurring themes
  - Simple keyword frequency analysis
  - Top 10 themes displayed in collapsible card
  - Themes shown in statistics view with visual bars
  - Filters common stop words automatically
- ✅ **Week 4: Smart Suggestions** - Suggest planting notes as seeds
  - AI suggests meaningful notes (150+ words, reflective mood)
  - "Plant as Seed" badges on qualifying notes
  - One-tap conversion from note to seed
  - AI settings integrated into onboarding flow

**Technical:**
- Zero ongoing costs ($0/month)
- Apple NaturalLanguage framework
- All processing on-device
- No API keys or servers needed
- Works completely offline

### ✅ v2.6 - Journal Refactor (COMPLETE)
**Simplified and refocused journaling experience:**
- ✅ Renamed "Quick Notes" → "Journal" throughout app
- ✅ Renamed `QuickNote` model → `JournalEntry`
- ✅ Two clear writing paths: Free Write or Prompted Writing
- ✅ Removed mood filtering from main UI (kept in stats)
- ✅ Simplified UX with focus on reflection over categorization
- ✅ Seed suggestions integrated for meaningful entries (150+ words)
- ✅ Updated all documentation and code comments

### 🔮 Future Development

Longer-term plans:
- **v2.7** - Cloud AI (optional premium features)
- **v3.0** - Mind Mapping & Thought Connections
  - See [MIND_MAP_IDEAS.md](.docs/MIND_MAP_IDEAS.md) for detailed concepts
  - Visual connections between entries
  - Branching thought threads
  - Discover patterns in reflections
- **v3.5** - Gamification & sharing
- **v4.0** - Premium features & monetization

## Testing

### Run Tests
```bash
# Unit tests
xcodebuild test -scheme Peony -destination 'platform=iOS Simulator,name=iPhone 15'

# Or press Cmd+U in Xcode
```

### Manual Testing Checklist

**Onboarding:**
- [ ] Complete onboarding flow (4 pages)
- [ ] Set notification time during onboarding

**Seeds (Garden Tab):**
- [ ] Plant a new seed with title and content
- [ ] Plant a seed with optional image
- [ ] Water a seed (verify daily limit)
- [ ] Build a watering streak (3+ days)
- [ ] Edit an existing seed
- [ ] Delete a seed (verify confirmation)
- [ ] View garden with multiple seeds at different growth stages

**Quick Notes (Notes Tab):**
- [ ] Create a new quick note
- [ ] View note in list (preview, word count)
- [ ] Open note detail view
- [ ] Edit an existing note
- [ ] Delete a note (verify confirmation)
- [ ] View empty state when no notes exist

**Navigation:**
- [ ] Switch between Garden and Notes tabs
- [ ] Verify tab bar icons and labels
- [ ] Verify growth percentage calculations
- [ ] Test full bloom at 100% (content reveal)

## Configuration

Core app settings in `Config.swift`:
```swift
enum AppConfig {
    static let defaultGrowthDays = 45           // Seeds bloom in 45 days
    static let wateringBonus = 1.0              // +1% per watering
    static let seedsPerBed = 9                  // Seeds per garden bed
}
```

## Known Issues & Future Improvements

### Before Next Release
- [ ] Replace placeholder URLs in Config.swift
- [ ] Add input validation for journal entries
- [ ] Improve database migration handling
- [ ] Add error handling for image loading

### Future Enhancements
See [ROADMAP.md](.docs/ROADMAP.md) for comprehensive future plans:
- Quick Notes feature (fast journaling)
- AI-powered writing prompts and insights
- Notifications system (redesigned)
- Export functionality (return)
- Accessibility improvements (VoiceOver, Dynamic Type)
- Dark mode support

## Contributing

This is a personal project currently in development. Feedback and suggestions are welcome!

## Documentation

- [ROADMAP.md](.docs/ROADMAP.md) - Future development plans
- [PHASE_1_COMPLETE.md](.docs/phases/PHASE_1_COMPLETE.md) - Phase 1 summary
- [PHASE_2_COMPLETE.md](.docs/phases/PHASE_2_COMPLETE.md) - Phase 2 summary
- [AUDIT_REPORT.md](.docs/audits/AUDIT_REPORT.md) - Comprehensive code audit

## Privacy & Security

- **Local-First** - All data stored locally using SwiftData
- **No Analytics** - Zero tracking or telemetry
- **No Ads** - Clean, distraction-free experience
- **User Control** - Edit or delete your entries anytime
- **Offline-First** - Works completely without internet

### Future AI Considerations
When AI features are added (v2.5+):
- All AI features will be opt-in
- Explicit user consent before sending data to cloud
- On-device Core ML as default for privacy
- API keys stored securely in Keychain
- Option to disable AI completely

## Credits

**Developer:** James Kinsey
**Version:** 2.6.0
**Platform:** iOS 17.0+
**Framework:** SwiftUI + SwiftData

## License

[To be determined]

---

**Made with 💚 and SwiftUI**

Transform your thoughts into a beautiful garden of growth. 🌱→🌸

