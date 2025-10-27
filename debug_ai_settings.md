# AI Settings Debug Guide

## 🔍 What to Check

### 1. Build and Run
Build the app fresh with all the new debug logs.

### 2. Check Console Output
You should now see detailed logs:

**When creating/editing a note:**
```
📝 QuickNote.detectAndSetMood() called for note [UUID]
📝 Mood detection enabled: true/false
🎭 MoodDetector: Analyzing text (length: XXX)
🎭 MoodDetector: Detected mood 'reflective' (score: 0.XX)
📝 Final detectedMood: reflective
```

**When viewing notes list:**
```
🌱 Seed suggestions enabled: true/false
🌱 Note word count: XXX (need 150+)
🌱 Note mood: reflective
🌱 Qualifies for seed: true/false
```

### 3. If You See "Mood detection enabled: false"

**Option A: Reset onboarding** (see AI settings page)
- Delete app from simulator
- Rebuild and run
- Complete onboarding and ENABLE mood detection on AI page

**Option B: Force enable in code** (temporary debug)
Add this to `PeonyApp.init()`:
```swift
init() {
    AppConfig.AI.registerDefaults()
    
    // Debug: Force enable all AI features
    UserDefaults.standard.set(true, forKey: "aiMoodDetectionEnabled")
    UserDefaults.standard.set(true, forKey: "aiSeedSuggestionsEnabled")
    UserDefaults.standard.set(true, forKey: "aiThemeAnalysisEnabled")
}
```

### 4. Create Test Note

Use this 152-word reflective note:

```
Today I found myself thinking deeply about how much I've grown over the past year. It's interesting to look back and see the person I was compared to who I am now. There were moments of doubt, times when I questioned whether I was on the right path, but somehow I kept moving forward.

I've learned that growth isn't always comfortable. Sometimes it means letting go of old patterns, old beliefs that no longer serve me. It means being willing to sit with uncertainty and trust that clarity will come in time.

The journey of self-discovery is ongoing. There's no final destination, no moment when everything suddenly makes perfect sense. Instead, it's a continuous unfolding, a gradual deepening of understanding. And I'm learning to be okay with that.

Looking ahead, I feel a quiet sense of excitement about what's possible when I stay open and curious.
```

### 5. Expected Results

After creating the note above, you should see:
- ✅ Console logs showing mood detection ran
- ✅ Mood emoji (🤔) on the note row
- ✅ 🌱 "Plant as Seed" badge on the note row
- ✅ Green "Plant This as a Seed" button in note detail

## 🐛 Common Issues

### Issue: "Mood detection enabled: false"
**Fix:** Settings not initialized. Reset onboarding or force enable (see Option B above).

### Issue: "Note mood: nil"
**Fix:** Mood detection didn't run. Check if it's being called in CreateNoteView/EditNoteView.

### Issue: Word count < 150
**Fix:** Note too short. Use the 152-word test note above.

### Issue: Mood is "joyful" or "peaceful"
**Fix:** Only reflective, grateful, thoughtful notes are suggested. The test note should detect as "reflective".

## 📋 Report Back

When you run the app, copy-paste the console output here. Look for lines starting with:
- 📝 (QuickNote logs)
- 🎭 (MoodDetector logs)
- 🌱 (SeedSuggestionEngine logs)

This will tell us exactly where the issue is!


