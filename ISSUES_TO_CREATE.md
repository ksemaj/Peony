# Critical Issues to Address
**Extracted from ACTION_CHECKLIST.md**

## 🔴 CRITICAL - Before Any Release

### Production Blockers
- [ ] Remove `fatalError()` from `Peony/PeonyApp.swift:102` - Add user-friendly error recovery for database failures
- [ ] Add alert option to reset data if database corrupted
- [ ] Fix version number in Config.swift (currently "2.6.0" - verify it matches README)

### Critical Safety Issues
- [ ] Remove `fatalError()` from PeonyApp.swift database initialization
- [ ] Add user-friendly error recovery for database failures
- [ ] Add alert option to reset data if database corrupted
- [ ] Fix prompt loading silent failure (add fallback prompts)

### Basic Testing
- [ ] Write unit test: `testGrowthPercentage_withNoWatering()`
- [ ] Write unit test: `testGrowthPercentage_withStreak()`
- [ ] Write unit test: `testStreakMultiplier_tierCalculation()`
- [ ] Write unit test: `testStreakBreak_after48Hours()`

## 🟡 HIGH PRIORITY - Next Sprint

### Data Safety & Export
- [ ] Implement JSON export for journal entries
- [ ] Add "Export All Data" button

### Accessibility
- [ ] Add `.accessibilityLabel()` to all interactive elements
- [ ] Test with VoiceOver enabled
- [ ] Support Dynamic Type (test with large text)

### Bug Fixes
- [ ] Fix watering edge case: use `isDate(_:inSameDayAs:)` instead of day comparison
- [ ] Add error handling for Prompts.json loading failure

---
**Note:** These items extracted from October 2024 audit. Some may have been addressed.

