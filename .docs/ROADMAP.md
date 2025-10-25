# Peony Roadmap 🌸

**Version:** 1.3.0  
**Last Updated:** October 25, 2025  
**Status:** Core Refined - Streaks & Notifications Active

---

## Current State (v1.3.0)

Phase 1 Core Refinement is complete!

### ✅ Core Features (Active)
- **Plant Seeds** - Create journal entries with text and optional images
- **Watering Streaks** - Build consecutive day streaks for bonus multipliers
  - Days 1-6: +1.0% per watering
  - Days 7-29: +1.5% per watering
  - Day 30+: +2.0% per watering
- **Growth Stages** - 5 stages from seed to full bloom (🌱→🌸)
- **45-Day Growth Cycle** - Default bloom time (can be reduced to ~15 days with perfect watering + streaks)
- **Hidden Content** - Journal entries revealed only when fully bloomed
- **Garden View** - Beautiful visual garden with optimized animations
- **Edit & Delete** - Modify or remove seeds
- **Onboarding** - First-time user tutorial
- **Notifications** - Bloom alerts, optional watering reminders, weekly check-ins
- **Notification Settings** - Minimal settings for notification preferences

---

## Phase 1.5: Onboarding Enhancement
**Target:** v1.3.1  
**Timeline:** 1 week  
**Focus:** Better first-time experience

### Goal
Improve onboarding flow to set notification preferences upfront instead of requiring users to dig into settings.

### Implementation
- [ ] **Add Notification Setup Card to Onboarding**
  - New onboarding step after tutorial/garden intro
  - Request notification permission
  - Let users set preferred watering reminder time
  - Option to enable/disable weekly check-in
  - Default: Enable both with smart defaults (9 AM watering, Sunday 10 AM check-in)
  - Can always change later in settings

### Benefits
- Users set preferences when context is fresh
- Higher notification opt-in rate
- Better engagement from day 1
- Reduces friction of finding settings later
- Users understand notification value upfront

### UI Flow
```
Onboarding Flow:
1. Welcome screen
2. Tutorial (how seeds work)
3. ✨ NEW: Notification Setup
   - "Stay Connected to Your Garden"
   - Request permission
   - Time picker for watering reminder
   - Toggle for weekly check-in
   - Skip option for users who prefer not to
4. Plant first seed
```

---

## Phase 1: Core Refinement ✅ COMPLETED
**Version:** v1.3.0  
**Completed:** October 25, 2025

### Achievements
- ✅ Watering streak system with 3-tier multipliers
- ✅ Visual watering celebrations with milestone tracking
- ✅ Performance optimizations (.drawingGroup(), simplified animations)
- ✅ Complete notification system (bloom, watering, weekly)
- ✅ NotificationSettingsView for user preferences
- ✅ Streak UI (badges, stats, celebrations)
- ✅ Premium hooks documented in Config.swift

---

## Phase 2: Quick Notes + Seeds (Option 2)
**Target:** v2.0.0  
**Timeline:** 4-6 weeks  
**Focus:** Dual journaling modes

### Two Journaling Modes

#### 🌱 Seeds (Deep Reflection)
**Current experience - stays the same**
- For meaningful memories, emotions, milestones
- 45-day growth cycle with watering
- Hidden until bloom
- Full ceremony with title, content, photo
- Main garden view

#### 📝 Quick Notes (NEW)
**Immediate journaling for everyday thoughts**
- Always visible - no growth period
- Fast entry - just write and save
- Simpler UI than seeds
- Lives in separate "Journal" tab
- Can "promote" note to seed later

### UI Structure
```
Tab Bar:
├─ Garden (Seeds growing)
├─ Journal (Quick notes)
└─ Plant (Merged action)
    ├─ Plant a Seed
    └─ Quick Note
```

### Features
- [ ] Quick notes data model
- [ ] Journal tab with list view
- [ ] Fast note entry UI
- [ ] "Plant as Seed" promotion flow
- [ ] AI suggestion: "This note seems meaningful - plant it?"

---

## Phase 3: AI Assistant
**Target:** v2.5.0  
**Timeline:** 6-8 weeks  
**Focus:** Intelligent writing companion

### Privacy-First AI Architecture

#### Tier 1: On-Device (Free - Core ML)
- **Writing Prompts** - Context-aware daily prompts
- **Mood Detection** - Local sentiment analysis
- **Basic Autocompletion** - Writing assistance
- **Pattern Recognition** - Simple trend detection

#### Tier 2: Cloud AI (Premium - OpenAI/Claude)
- **Deep Insights** - AI-generated reflections on bloomed seeds
- **Advanced Prompts** - Personalized writing suggestions
- **Bloom Cards** - Beautiful AI-summarized growth insights
- **Pattern Analysis** - Complex emotional trend detection
- **Connection Discovery** - Link related entries

### Features
- [ ] AI provider configuration (OpenAI, Claude, Core ML)
- [ ] Secure API key storage (Keychain)
- [ ] Writing prompt system
- [ ] Mood/sentiment analysis
- [ ] Bloom insights generator
- [ ] Pattern recognition engine
- [ ] AI settings & consent management

### AI Garden Companion
- Visual character (butterfly or bee)
- Appears occasionally with prompts or insights
- Non-intrusive, mindful design
- Can be disabled completely

---

## Phase 4: Gamification & Social
**Target:** v3.0.0  
**Timeline:** 6-8 weeks  
**Focus:** Engagement and sharing

### Achievements System
- [ ] Growth milestones (first seed, 10 seeds, etc.)
- [ ] Watering streaks (7 days, 30 days, etc.)
- [ ] Garden varieties (plant different types)
- [ ] Seasonal achievements
- [ ] Writing consistency badges
- [ ] Beautiful achievement cards

### Garden Statistics
- [ ] Growth dashboard
  - Seeds planted over time
  - Watering frequency
  - Bloom timeline
  - Mood trends (if AI enabled)
- [ ] Personal insights
- [ ] Year in review
- [ ] Garden health score

### Sharing Features
- [ ] **iMessage Integration** - Share bloomed seeds beautifully
  - Rich card preview
  - Custom designs per growth stage
  - Privacy controls (share text only, with/without photo)
- [ ] Export bloomed seeds as images
- [ ] Garden snapshot sharing
- [ ] QR code for sharing seeds

---

## Phase 5: Customization & Accessibility
**Target:** v3.5.0  
**Timeline:** 4-6 weeks  
**Focus:** Personalization and inclusivity

### Visual Customization
- [ ] **Dark Mode** - Full dark theme support
- [ ] **Garden Themes**
  - Spring Meadow (default)
  - Japanese Zen Garden
  - Desert Oasis
  - Enchanted Forest
  - Winter Wonderland
  - Autumn Harvest
- [ ] **Custom Plant Varieties**
  - Different flower types (roses, orchids, sunflowers)
  - Succulents
  - Fruit trees
  - Vegetables
  - Magical/fantasy plants
- [ ] **Typography Options**
  - Different font families
  - Size adjustments
  - Reading mode

### Accessibility
- [ ] VoiceOver support
- [ ] Dynamic Type
- [ ] High contrast mode
- [ ] Reduced motion options
- [ ] Color blind friendly palettes

### Localization
- [ ] Translation framework
- [ ] Spanish (es)
- [ ] French (fr)
- [ ] German (de)
- [ ] Japanese (ja)
- [ ] Chinese Simplified (zh-Hans)
- [ ] More languages based on demand

---

## Phase 6: Monetization
**Target:** v4.0.0  
**Timeline:** 2-3 weeks  
**Focus:** Sustainable business model

### Free Tier: Garden Starter 🌱
- **5 active seed slots** (can delete and plant new ones)
- **Unlimited quick notes**
- **45-day fixed growth period**
- **Basic plant visualizations only**
- **On-device AI prompts** (Core ML)
- **Standard garden theme**
- **Basic notifications**
- **Export** - JSON only

### Premium Tier: Garden Unlimited 🌸
**Pricing Options:**
- **Subscription:** $3.99/month or $29.99/year
- **Lifetime:** $39.99 one-time payment

**Premium Features:**
- ✨ **Unlimited seeds**
- ✨ **Unlimited notes**
- ✨ **Full AI features** (Cloud + on-device)
  - Advanced insights
  - Personalized prompts
  - Bloom cards with AI summaries
- ✨ **Custom growth duration** (14-365 days)
- ✨ **Premium plant varieties**
- ✨ **All garden themes**
- ✨ **Advanced exports** (PDF with custom designs, HTML garden gallery)
- ✨ **Cloud backup & sync** (future)
- ✨ **Priority support**
- ✨ **Early access** to new features

### Add-Ons (Optional IAP)
Individual purchases for specific features:
- **Theme Packs** ($2.99-4.99)
  - Japanese Zen Garden
  - Desert Oasis
  - Enchanted Forest
  - Each includes unique plants & decorations
  
- **Plant Packs** ($1.99-2.99)
  - Exotic Flowers
  - Succulent Collection
  - Fruit Trees
  - Magical Plants

- **Export Templates** ($0.99-2.99)
  - Beautiful PDF layouts
  - Custom garden books
  - Anniversary editions

### Implementation
- [ ] StoreKit 2 integration
- [ ] Subscription management
- [ ] Paywall design
- [ ] Free trial (7 days)
- [ ] Family sharing support
- [ ] Student discount (50% off)
- [ ] Restore purchases
- [ ] Receipt validation

---

## Future Considerations
**Post v4.0.0 - Ideas for Exploration**

### Advanced Features
- **Cloud Sync** - Sync across devices (iPad, Mac)
- **Collaboration** - Shared gardens with friends/family
- **Garden Timeline** - Historical view of all growth
- **Widgets** - Home screen garden widget
- **Watch App** - Quick watering from Apple Watch
- **Mac App** - Full macOS experience

### Wellness Integration
- **Therapy Mode** - White-label for therapists
- **Corporate Wellness** - Team journaling
- **Educational** - School mental health programs
- **Health App Integration** - Mindful minutes tracking

### Companion Products
- **Physical Journals** - Peony-branded notebooks
- **Prints** - Custom garden artwork
- **Merchandise** - T-shirts, stickers, etc.
- **Guided Meditations** - Audio mindfulness content

---

## Development Principles

### Always Maintain
1. **Simplicity First** - Don't overcomplicate the core experience
2. **Privacy Paramount** - User data stays private, local by default
3. **Mindful Design** - Every feature should reduce stress, not add it
4. **Performance** - App must feel fast and responsive
5. **Beauty** - Visual aesthetics are core to the experience

### Never Do
1. ❌ Add ads - ever
2. ❌ Sell user data
3. ❌ Manipulative notifications
4. ❌ Dark patterns in monetization
5. ❌ Required subscription for core features

---

## Success Metrics

### User Engagement
- Daily active users
- Watering frequency
- Seeds planted per user
- Retention rates (D1, D7, D30)
- Time to first bloom

### Business Health
- Conversion rate (free → premium)
- Monthly recurring revenue
- Churn rate
- Lifetime value
- App Store rating

### Wellness Impact
- User-reported benefits (surveys)
- Journaling consistency
- Completion rates (seeds → blooms)
- Feature usage patterns

---

## Version History

- **v1.0.0** - Initial release (Phase 1)
- **v1.1.0** - Technical cleanup (Phase 2)
- **v1.2.0** - Soft reset to core experience (Current)
- **v1.3.0** - Refined notifications & watering (Planned)
- **v2.0.0** - Quick Notes implementation (Planned)
- **v2.5.0** - AI Assistant (Planned)
- **v3.0.0** - Gamification & Social (Planned)
- **v3.5.0** - Customization & Accessibility (Planned)
- **v4.0.0** - Monetization launch (Planned)

---

**Made with 💚 and SwiftUI**

Transform your thoughts into a beautiful garden of growth. 🌱→🌸

