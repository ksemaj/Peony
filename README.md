# Peony 🌸

A mindful journaling app where your thoughts grow into beautiful flowers.

## Overview

Peony transforms the journaling experience by gamifying personal growth. Each journal entry is a "seed" that grows over time, blooming into a flower after 90 days. Daily watering creates a habit loop that encourages consistent reflection.

## Features

### Core Functionality
- 🌱 **Plant Seeds** - Create journal entries with text and optional images
- 💧 **Daily Watering** - Water your seeds to speed up growth (+1% per day)
- 🌸 **Watch Them Bloom** - Seeds progress through 5 growth stages
- 📊 **Track Progress** - Monitor growth percentage and milestones
- 🔔 **Smart Notifications** - Growth milestones, watering reminders, and weekly check-ins
- 📤 **Export Your Journey** - Export to JSON or PDF formats
- ⚙️ **Customizable** - Adjust growth duration from 30-365 days

### Growth Stages
1. **Seed** (0-24%) - 🌱 Just planted
2. **Sprout** (25-49%) - 🌿 First leaves appear
3. **Growing** (50-74%) - 🪴 Stem develops
4. **Budding** (75-99%) - 🌺 Bud forms
5. **Full Bloom** (100%) - 🌸 Journal entry revealed!

### Unique Mechanics
- **Hidden Content** - Journal entries are hidden until seeds fully bloom
- **Watering Bonus** - Each watering adds 1% growth (can reduce bloom time by ~50%)
- **Beautiful Garden** - Custom-drawn plants, trees, and decorative flora
- **Mindful Design** - Pastel colors and smooth animations create a calming experience

## Technical Details

### Requirements
- **iOS:** 17.0+
- **Xcode:** 15.0+
- **Swift:** 5.9+
- **SwiftData** for data persistence
- **UserNotifications** for reminders

### Architecture

```
Peony/
├── PeonyApp.swift              # App entry point
├── ContentView.swift           # Main garden view
├── OnboardingView.swift        # First-time user experience
├── Models/
│   ├── JournalSeed.swift       # Core data model
│   ├── GrowthStage.swift       # Growth stage enum
│   ├── ColorExtensions.swift   # Design system colors
│   └── Config.swift            # App configuration
├── Views/
│   └── Shared/
│       └── SettingsView.swift  # User preferences
├── Utilities/
│   ├── NotificationManager.swift  # Push notification handling
│   └── ExportManager.swift        # JSON/PDF export
└── Components/                 # Custom UI components
    ├── Flora/                  # (Ready for extraction)
    ├── Plants/                 # (Ready for extraction)
    └── UI/                     # (Ready for extraction)
```

### Design Patterns
- **MVVM Architecture** - Clear separation of concerns
- **SwiftUI + SwiftData** - Modern Apple frameworks
- **Singleton Managers** - NotificationManager, ExportManager
- **Computed Properties** - For derived values (growth %, stage)
- **Custom Components** - Reusable plant and flora views

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

### ✅ Phase 1: Core UX (Completed)
- 90-day growth timeline
- Edit & delete functionality
- Watering mechanic
- Search & filter system
- Push notifications
- Settings view

### ✅ Phase 2: Technical Cleanup (Completed)
- Extracted models to separate files
- Created folder structure
- Built ExportManager (JSON/PDF)
- Centralized configuration (Config.swift)
- Moved utilities to proper locations

### 🚧 Phase 3: AI Integration (Planned)
- AI-generated reflections & insights
- Smart writing prompts
- Mood detection
- Pattern recognition
- Personalized recommendations
- Support for OpenAI, Claude, and Apple Core ML

## Testing

### Run Tests
```bash
# Unit tests
xcodebuild test -scheme Peony -destination 'platform=iOS Simulator,name=iPhone 15'

# Or press Cmd+U in Xcode
```

### Manual Testing Checklist
- [ ] Plant a new seed
- [ ] Water a seed
- [ ] Edit an existing seed
- [ ] Delete a seed
- [ ] Search for seeds
- [ ] Filter by growth stage
- [ ] Export to JSON
- [ ] Export to PDF
- [ ] Adjust settings
- [ ] Complete onboarding flow

## Known Issues

See [AUDIT_REPORT.md](AUDIT_REPORT.md) for comprehensive list.

### High Priority (Before Release)
- [ ] Replace `example.com` URLs in Config.swift with actual links
- [ ] Clean up macOS resource fork files
- [ ] Add error alerts for export failures
- [ ] Implement input validation

### Medium Priority
- [ ] Improve database migration (add backup)
- [ ] Reduce notification spam (one daily reminder instead of per-seed)
- [ ] Add accessibility labels for VoiceOver

### Low Priority
- [ ] Extract components from ContentView.swift
- [ ] Add comprehensive unit tests
- [ ] Support Dynamic Type

## Configuration

### Growth Settings
Adjust in `Config.swift`:
```swift
enum AppConfig {
    static let defaultGrowthDays = 90        // Default bloom time
    static let minGrowthDays = 30            // Minimum allowed
    static let maxGrowthDays = 365           // Maximum allowed
    static let wateringBonus = 1.0           // Percentage per watering
}
```

### Notification Times
```swift
static let wateringReminderHour = 9          // 9 AM
static let weeklyCheckinWeekday = 1          // Sunday
static let weeklyCheckinHour = 10            // 10 AM
```

## Export Formats

### JSON Structure
```json
{
  "version": "1.1.0",
  "exportDate": "2025-10-25T12:00:00Z",
  "seeds": [
    {
      "id": "UUID",
      "title": "My First Seed",
      "content": "Journal entry content...",
      "plantedDate": "2025-01-01T00:00:00Z",
      "growthPercentage": 50.0,
      "growthStage": "Growing",
      "timesWatered": 10,
      "growthDurationDays": 90,
      "hasImage": true
    }
  ]
}
```

### PDF Format
- One page per seed
- Title, date, and growth info at top
- Full content (if bloomed)
- Embedded images
- Page numbers

## Contributing

This is a personal project currently in development. Feedback and suggestions are welcome!

## Documentation

- [PHASE_1_COMPLETE.md](PHASE_1_COMPLETE.md) - Phase 1 summary
- [PHASE_2_COMPLETE.md](PHASE_2_COMPLETE.md) - Phase 2 summary
- [PHASE_2_NEXT_STEPS.md](PHASE_2_NEXT_STEPS.md) - Setup instructions
- [AUDIT_REPORT.md](AUDIT_REPORT.md) - Comprehensive code audit

## Privacy & Security

- **Local Storage** - All data stored locally using SwiftData
- **No Analytics** - No tracking or telemetry
- **Optional Notifications** - User can disable all notifications
- **Export Control** - User owns their data (JSON/PDF export)

### Phase 3 AI Considerations
- All AI features will be opt-in
- User consent required before sending data to AI services
- On-device Core ML option for privacy-conscious users
- API keys stored securely in Keychain (never in code)

## Credits

**Developer:** James Kinsey  
**Version:** 1.1.0  
**Platform:** iOS 17.0+  
**Framework:** SwiftUI + SwiftData

## License

[To be determined]

---

**Made with 💚 and SwiftUI**

Transform your thoughts into a beautiful garden of growth. 🌱→🌸

