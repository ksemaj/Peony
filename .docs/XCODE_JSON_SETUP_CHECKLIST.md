# Xcode JSON Setup Checklist

**Goal:** Get `Prompts.json` properly loading from app bundle

**Status:** Follow these steps in order ✅

---

## ✅ Pre-flight Check

- [x] File exists at: `/Users/james/Documents/dev/ios apps/Peony/Peony/Prompts.json`
- [x] File size: 8.8KB
- [x] File contains: 60 prompts in valid JSON format
- [x] Code updated to pure JSON loading (no hardcoded fallback)

---

## 🎯 Step-by-Step Instructions

### Step 1: Open Project
- [ ] Launch Xcode
- [ ] Open Peony.xcodeproj
- [ ] Ensure Project Navigator visible (Cmd+1)

### Step 2: Add File to Xcode
- [ ] Right-click "Peony" folder (blue folder icon) in Project Navigator
- [ ] Select "Add Files to 'Peony'..."
- [ ] Navigate to: `Peony/Prompts.json`
- [ ] **Settings to verify:**
  - [ ] ☐ **UNCHECK** "Copy items if needed"
  - [ ] ⦿ **SELECT** "Create groups" (not folder references)
  - [ ] ☑ **CHECK** "Add to targets: Peony"
- [ ] Click "Add"

### Step 3: Verify File Added
- [ ] `Prompts.json` appears in Project Navigator
- [ ] File is **NOT greyed out**
- [ ] File shows document icon (not folder)

### Step 4: Check Build Phase
- [ ] Click project icon (blue "Peony" at top)
- [ ] Select "Peony" target (under TARGETS)
- [ ] Click "Build Phases" tab
- [ ] Expand "Copy Bundle Resources"
- [ ] Verify `Prompts.json` is in the list
- [ ] If missing: Click "+", add `Prompts.json`

### Step 5: Clean Build
- [ ] Press `Shift + Cmd + K` (Clean Build Folder)
- [ ] Wait for completion
- [ ] Press `Cmd + B` (Build)
- [ ] Verify build succeeds with no errors

### Step 6: Run & Verify
- [ ] Press `Cmd + R` (Run)
- [ ] Check Xcode console for:
  - ✅ `"✅ Loaded 60 writing prompts from Prompts.json"`
  - ❌ NOT `"❌ ERROR: Prompts.json not found in bundle"`

### Step 7: Test in App
- [ ] Navigate to Notes tab
- [ ] Create at least one quick note (if empty)
- [ ] Verify prompt card appears at top
- [ ] Prompt shows text like "What made you smile today?"
- [ ] Tap "Start Writing" - creates note with prompt
- [ ] Tap "Skip" - shows different prompt

### Step 8: Verify Bundle (Optional)
Run verification script:
```bash
cd "/Users/james/Documents/dev/ios apps/Peony"
./verify_bundle.sh
```

Expected output:
```
✅ SUCCESS! Prompts.json is in the app bundle
```

---

## 🚨 Troubleshooting

### Problem: File is greyed out
**Solution:**
1. Right-click `Prompts.json` → Delete Reference
2. Re-add using Step 2, ensure "Create groups" selected

### Problem: Not in "Copy Bundle Resources"
**Solution:**
1. Project → Target → Build Phases
2. Expand "Copy Bundle Resources"
3. Click "+" → Add `Prompts.json`

### Problem: Still showing error after adding
**Solution:**
```bash
# Close Xcode first
rm -rf ~/Library/Developer/Xcode/DerivedData/Peony-*
# Reopen Xcode and rebuild
```

### Problem: File path seems wrong
**Solution:**
1. Select `Prompts.json` in navigator
2. Open File Inspector (Cmd+Opt+1)
3. Check "Location" - should be relative to project
4. If wrong, click folder icon to relocate

---

## ✅ Success Criteria

You'll know it's working when you see ALL of these:

1. **Console output:**
   ```
   ✅ Loaded 60 writing prompts from Prompts.json
   ```

2. **In app:**
   - Beautiful prompt card at top of Notes tab
   - Shows one of 60 different prompts
   - "Start Writing" button works
   - "Skip" button gets new prompt

3. **Code is clean:**
   - No hardcoded fallback prompts
   - `PromptGenerator.swift` is ~100 lines
   - Pure JSON loading only

---

## 📊 Before & After

### Before (Hybrid with Hardcoded Fallback)
```swift
private func loadPrompts() {
    // Try JSON
    if let url = Bundle.main.url(...) { }
    
    // Fallback to hardcoded
    else { allPrompts = Self.defaultPrompts }
}

private static let defaultPrompts: [WritingPrompt] = [
    // ... 60 hardcoded prompts (160 lines) ...
]
```
**File size:** ~200 lines

### After (Pure JSON)
```swift
private func loadPrompts() {
    guard let url = Bundle.main.url(forResource: "Prompts", withExtension: "json") else {
        print("❌ ERROR: Prompts.json not found in bundle")
        allPrompts = []
        return
    }
    
    guard let data = try? Data(contentsOf: url),
          let prompts = try? JSONDecoder().decode([WritingPrompt].self, from: data) else {
        print("❌ ERROR: Could not decode Prompts.json")
        allPrompts = []
        return
    }
    
    allPrompts = prompts
    print("✅ Loaded \(allPrompts.count) writing prompts from Prompts.json")
}
```
**File size:** ~100 lines
**Prompts location:** `Peony/Prompts.json` (separate file)

---

## 🎉 Benefits Once Working

### Immediate:
✅ Clean code separation (logic vs content)
✅ Easier to edit prompts (just JSON)
✅ No giant Swift arrays cluttering code
✅ Better code reviews (content separate)

### Future:
✅ Can add more prompts easily
✅ Can create seasonal prompt files
✅ Can support multiple languages
✅ Can A/B test different prompts
✅ Can load prompts from server

---

## 📝 Notes

- `Prompts.json` is **8.8KB** - negligible impact on app size
- File is copied to bundle during build (no runtime cost)
- JSON parsing happens once at startup (~10ms)
- Pure JSON is industry standard for content
- Once working, very reliable going forward

---

## 🆘 Need Help?

If you're stuck:
1. Check each step carefully
2. Try troubleshooting solutions
3. Run `verify_bundle.sh` to diagnose
4. Try clean + rebuild
5. Try deleting derived data

**Remember:** This is a one-time setup issue. Once it works, it works forever!

---

**Created:** October 26, 2025
**For:** Peony v2.5.1 - Week 2 (Writing Prompts)


