# Peony Testing Guide

**Version:** 2.0.0  
**Last Updated:** October 26, 2025

---

## Quick Tests for v2.0 Statistics Feature

### Testing NotesStatsView

#### Test 1: Empty State
1. Open the app (fresh install or delete all notes)
2. Navigate to Notes tab
3. Tap the chart icon (📊) in the top-left
4. **Expected:** See "Start writing to see your statistics!" message
5. **Verify:** All stats show 0

#### Test 2: Single Note
1. Create one quick note with ~50 words
2. Open statistics view
3. **Expected:**
   - Total Notes: 1
   - Total Words: ~50
   - Average Words: ~50
   - This Week: 1
   - This Month: 1

#### Test 3: Multiple Notes
1. Create 5 notes with varying word counts (10, 50, 100, 200, 500 words)
2. Open statistics view
3. **Expected:**
   - Total Notes: 5
   - Total Words: 860
   - Average Words: 172
   - This Week: 5
   - This Month: 5

#### Test 4: Time Filtering
1. Use a date picker/system date to create notes from different time periods:
   - 2 notes today
   - 2 notes 5 days ago
   - 2 notes 20 days ago
   - 2 notes 40 days ago
2. Open statistics view
3. **Expected:**
   - This Week: 4 (today + 5 days ago)
   - This Month: 6 (all except 40 days ago)
   - Total: 8

---

## Complete Feature Testing Checklist

### Seeds (Garden Tab)
- [ ] Plant a new seed with title and content
- [ ] Plant a seed with an image
- [ ] Water a seed (verify +1% growth)
- [ ] Water daily to build a streak
- [ ] Verify streak multipliers (7 days = 1.5x, 30 days = 2.0x)
- [ ] Edit a seed's content
- [ ] Delete a seed (confirm deletion works)
- [ ] View seed detail (verify all stats displayed)
- [ ] Wait for seed to bloom (or manually test at 100%)
- [ ] Verify content is hidden until 100% bloom

### Quick Notes (Notes Tab)
- [ ] Create a note with content
- [ ] Try to create note with empty content (should be disabled)
- [ ] Edit an existing note
- [ ] Delete a note (confirm dialog appears)
- [ ] Search for notes by content
- [ ] Filter by "This Week"
- [ ] Filter by "This Month"
- [ ] View statistics (all metrics calculate correctly)
- [ ] Verify word counts are accurate
- [ ] Navigate between Garden and Notes tabs

### Navigation & UX
- [ ] Tab switching is smooth
- [ ] Animations play correctly
- [ ] Haptic feedback works on interactions
- [ ] Empty states display properly
- [ ] Back buttons work correctly
- [ ] Dismiss gestures work on sheets

### Onboarding
- [ ] Complete all 5 onboarding pages
- [ ] Set notification time
- [ ] Verify notifications are scheduled
- [ ] Re-open onboarding from Garden tab (? button)

### Notifications
- [ ] Test notification (bell icon in Garden)
- [ ] Verify bloom notification (after seed reaches 100%)
- [ ] Check daily watering reminder
- [ ] Check weekly check-in

### Edge Cases
- [ ] Very long note content (1000+ words)
- [ ] Special characters in search
- [ ] Empty search results
- [ ] 100+ notes (performance test)
- [ ] Multiple seeds at same growth stage
- [ ] Seeds planted on same day

---

## Performance Testing

### Load Testing
1. Create 100 seeds
2. Create 100 notes
3. **Verify:**
   - App launches quickly (<2s)
   - Scrolling is smooth (60 FPS)
   - Search is instant (<100ms)
   - Statistics calculate quickly (<500ms)

### Memory Testing
1. Create 500 notes with images
2. Switch between tabs multiple times
3. **Verify:**
   - No memory leaks
   - No crashes
   - App stays under 100MB RAM

---

## Device Testing Matrix

### iOS Devices
- [ ] iPhone SE (small screen)
- [ ] iPhone 15 (standard)
- [ ] iPhone 15 Pro Max (large screen)
- [ ] iPad (if supported)

### iOS Versions
- [ ] iOS 17.0 (minimum supported)
- [ ] iOS 17.5 (latest stable)
- [ ] iOS 18 beta (if available)

---

## Accessibility Testing

### VoiceOver
- [ ] Navigate with VoiceOver enabled
- [ ] All buttons have labels
- [ ] All images have alt text
- [ ] Tab navigation works correctly

### Dynamic Type
- [ ] Test with smallest text size
- [ ] Test with largest text size
- [ ] Verify layouts don't break
- [ ] Verify readability maintained

### Other
- [ ] Test with Reduce Motion enabled
- [ ] Test with High Contrast enabled
- [ ] Test in Dark Mode (future feature)

---

## Known Issues

### Current (v2.0.0)
- None identified

### Future Improvements
- Add note export functionality
- Add swipe-to-delete in notes list
- Add note templates
- Add note categories/tags UI
- Add writing streaks for notes

---

## Regression Testing (Before Each Release)

1. Plant a seed and water it daily for 7 days
2. Create 10 quick notes over different days
3. Search and filter notes
4. View statistics
5. Complete onboarding flow
6. Test notifications
7. Delete seeds and notes
8. Verify no crashes or data loss

---

## Automated Testing (Future)

### Unit Tests Needed
- [ ] QuickNote model methods
- [ ] Date filtering logic
- [ ] Statistics calculations
- [ ] Word count accuracy
- [ ] Search filtering

### UI Tests Needed
- [ ] Create and delete note flow
- [ ] Search and filter flow
- [ ] Tab navigation
- [ ] Statistics view presentation

---

## Bug Reporting Template

**Title:** Brief description

**Steps to Reproduce:**
1. Step 1
2. Step 2
3. Step 3

**Expected:** What should happen

**Actual:** What actually happened

**Device:** iPhone model, iOS version

**Screenshots:** If applicable

**Logs:** Relevant console output

---

**Happy Testing!** 🧪🌸


