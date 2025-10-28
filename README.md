# Peony

A mindful journaling app where your thoughts grow into beautiful flowers.

## Overview

Peony transforms journaling into a garden-growing experience. Write journal entries that grow into flowers through daily care and reflection.

## Features

- **🌱 Plant Seeds** - Create journal entries (content hidden until bloom)
- **💧 Daily Watering** - Nurture your seeds to speed up growth
- **🌸 Growth Stages** - Watch seeds progress: Seed → Sprout → Stem → Bud → Flower
- **🔥 Streak System** - Daily care bonuses for consistency
- **📔 Journal Mode** - Quick notes with AI-powered insights
- **🎨 Beautiful Design** - Custom plant animations and time-aware backgrounds

## Getting Started

```bash
git clone https://github.com/ksemaj/Peony.git
cd Peony
open Peony.xcodeproj
```

Requires Xcode 15.0+ and iOS 16.0+

## Architecture

Clean, modular SwiftUI architecture with proper separation of concerns:

```
Peony/
├── Components/     # Reusable UI components
├── Views/          # Screen-level views
├── Models/         # SwiftData models
└── Utilities/      # Business logic & AI
```

## Tech Stack

- **SwiftUI** - Modern iOS UI framework
- **SwiftData** - Data persistence
- **NaturalLanguage** - On-device AI features
- **Custom Architecture** - MVVM with component-based structure

## Privacy

- All AI processing happens on-device using Apple's NaturalLanguage framework
- No analytics or tracking
- Data stored locally using SwiftData
- User maintains full control

## Status

✅ Active Development  
🚀 Version 2.6.0  
📱 iOS 16.0+

---

**Built with ❤️ in SwiftUI**
