# Critical Issues to Address
**Extracted from ACTION_CHECKLIST.md**

## 🔴 CRITICAL - Before Any Release

### Production Blockers
- [x] Remove `fatalError()` from `Peony/PeonyApp.swift:102` - Add user-friendly error recovery for database failures ✅ **COMPLETE** (DatabaseManager handles errors gracefully)
- [x] Add alert option to reset data if database corrupted ✅ **COMPLETE** (Alert present in PeonyApp.swift)
- [x] Fix version number in Config.swift (currently "2.6.0" - verify it matches README) ✅ **COMPLETE** (Both show 2.6.0)

### Critical Safety Issues
- [x] Remove `fatalError()` from PeonyApp.swift database initialization ✅ **COMPLETE**
- [x] Add user-friendly error recovery for database failures ✅ **COMPLETE**
- [x] Add alert option to reset data if database corrupted ✅ **COMPLETE**
- [x] Fix prompt loading silent failure (add fallback prompts) ✅ **COMPLETE** (Fallback prompts implemented)

### Basic Testing
- [x] Write unit test: `testGrowthPercentage_withNoWatering()` ✅ **COMPLETE**
- [x] Write unit test: `testGrowthPercentage_withStreak()` ✅ **COMPLETE**
- [x] Write unit test: `testStreakMultiplier_tierCalculation()` ✅ **COMPLETE**
- [x] Write unit test: `testStreakBreak_after48Hours()` ✅ **COMPLETE**

## 🟡 HIGH PRIORITY - Next Sprint

### Data Safety & Export
- [x] Implement JSON export for journal entries ✅ **COMPLETE** (DataExporter.swift)
- [x] Add "Export All Data" button ✅ **COMPLETE** (ExportDataView accessible from NotesView)

### Accessibility
- [x] Add `.accessibilityLabel()` to all interactive elements ✅ **COMPLETE** (All buttons, links, and interactive elements have accessibility labels)
- [x] Test with VoiceOver enabled ✅ **COMPLETE** (Tested in simulator with Accessibility Inspector - all accessibility labels verified and working correctly)
- [x] Support Dynamic Type (test with large text) ✅ **COMPLETE & TESTED** ✅ (Font extensions updated to use UIFont.preferredFont, system fonts used throughout, .dynamicTypeSize caps added to prevent oversized text. Tested in simulator - working correctly!)

### Bug Fixes
- [x] Fix watering edge case: use `isDate(_:inSameDayAs:)` instead of day comparison ✅ **COMPLETE** (Already using `isDate(_:inSameDayAs:)` in JournalSeed.swift)
- [x] Add error handling for Prompts.json loading failure ✅ **COMPLETE** (Fallback prompts implemented in PromptGenerator)

---
**Note:** These items extracted from October 2024 audit. Some may have been addressed.

