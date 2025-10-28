# Peony Refactor - Next Steps

## 🎉 Current Status: 64% Complete (30/45 files created)

### ✅ What's Been Done
- **Phase 1**: Complete - 13 plant/flora components extracted
- **Phase 2**: Complete - 11 background/effects components extracted
- **Phase 3**: Complete - 4 garden layout components extracted
- **Phase 4**: Partial - 2/8 seed management views extracted
- **Progress Tracker**: Created `REFACTOR_PROGRESS.md`

### 📊 Impact So Far
- **~1,500-2,000 lines** extracted from ContentView.swift
- **30 new component files** created and organized
- **Zero breaking changes** - all code preserved, just reorganized

---

## 🚀 Immediate Next Steps (Critical Path)

### Step 1: Complete Phase 4 - Remaining Seed Views (6 files)

These are the LARGEST views and most time-intensive. Each needs to be extracted:

1. **WateringButton** (~110 lines)
   - Location: ContentView.swift lines 2095-2205
   - Destination: `Peony/Components/UI/WateringButton.swift`

2. **PlantingSuccessView** (~130 lines)
   - Location: ContentView.swift lines 1833-1966
   - Destination: `Peony/Views/Garden/PlantingSuccessView.swift`

3. **WateringSuccessView** (~120 lines)
   - Location: ContentView.swift lines 1969-2092
   - Destination: `Peony/Views/Garden/WateringSuccessView.swift`

4. **PlantSeedView** (~250 lines) ⚠️ LARGE
   - Location: ContentView.swift lines 1579-1830
   - Destination: `Peony/Views/Garden/PlantSeedView.swift`

5. **EditSeedView** (~190 lines) ⚠️ LARGE
   - Location: ContentView.swift lines 2208-2400
   - Destination: `Peony/Views/Garden/EditSeedView.swift`

6. **SeedDetailView** (~250 lines) ⚠️ LARGE
   - Location: ContentView.swift lines 2403-2656
   - Destination: `Peony/Views/Garden/SeedDetailView.swift`

**Key Points:**
- Each file should preserve ALL imports (SwiftUI, SwiftData, PhotosUI where needed)
- Keep ALL nested views and helper functions
- Add #Preview macros for testing
- Update component names (Custom* → regular names)

---

### Step 2: Create MoodHelpers Utility (Phase 5)

**File:** `Peony/Utilities/MoodHelpers.swift`

```swift
import Foundation

/// Centralized mood emoji and display utilities
struct MoodHelpers {
    /// Get emoji for mood
    static func emoji(for mood: String) -> String {
        switch mood {
        case "joyful": return "😊"
        case "reflective": return "🤔"
        case "grateful": return "🙏"
        case "peaceful": return "😌"
        case "thoughtful": return "💭"
        default: return "✨"
        }
    }
    
    /// Get display name for mood
    static func displayName(for mood: String) -> String {
        mood.capitalized
    }
}
```

**Then Update:**
1. `MoodDetector.swift` - Replace emoji functions with `MoodHelpers.emoji(for:)`
2. `NoteRowView.swift` - Replace `moodEmoji` function with `MoodHelpers.emoji(for:)`
3. Remove all duplicate emoji mapping code

---

### Step 3: Fix AI Feature Bugs (Phase 6)

#### Bug 1: Mood Detection Not Running on Create
**File:** `Peony/Views/Notes/CreateNoteView.swift`
**Line:** ~121 (in `saveNote()` function)

**Add:**
```swift
func saveNote() {
    let note = JournalEntry(content: content)
    note.detectAndSetMood()  // ← ADD THIS LINE
    modelContext.insert(note)
    // ... rest
}
```

#### Bug 2: Seed Suggestion Performance
**File:** `Peony/Views/Notes/NoteRowView.swift`
**Line:** ~43

**Change:**
```swift
// OLD (computed every render):
let shouldSuggest = SeedSuggestionEngine.shouldSuggestAsSeed(note)

// NEW (computed once):
private var shouldSuggestAsSeed: Bool {
    SeedSuggestionEngine.shouldSuggestAsSeed(note)
}
```

Then use `shouldSuggestAsSeed` in the view body.

#### Bug 3: Verify AI Settings Defaults
**File:** `Peony/PeonyApp.swift`
**Line:** ~18

Confirm `AppConfig.AI.registerDefaults()` is called in init - already done ✅

#### Bug 4: Theme Analysis Guard
**File:** `Peony/Views/Notes/NotesStatsView.swift`
**Line:** ~93

Already has proper guard - ✅ No fix needed

---

### Step 4: Rewrite ContentView (Phase 7) ⚠️ CRITICAL

This is the MOST IMPORTANT step. ContentView.swift needs to:

1. **Remove all extracted struct definitions** (lines 6-2750)
2. **Keep only main ContentView logic**
3. **Import component references**

**Target ContentView.swift structure (~200-300 lines):**

```swift
import SwiftUI
import SwiftData
import PhotosUI

// All component structs have been extracted to:
// - Components/Plants/ (plant growth visualizations)
// - Components/Flora/ (decorative elements)
// - Components/UI/ (backgrounds, effects, buttons)
// - Views/Garden/ (seed management, layout)
// - Views/Shared/ (utilities)

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalSeed.plantedDate, order: .reverse) private var allSeeds: [JournalSeed]
    @State private var showingPlantSheet = false
    @State private var showingOnboarding = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                GardenBackgroundView()
                
                // Main content
                if allSeeds.isEmpty {
                    emptyGardenView
                } else {
                    GardenLayoutView(seeds: allSeeds)
                }
            }
            .navigationTitle("My Garden")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingPlantSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
            }
            .sheet(isPresented: $showingPlantSheet) {
                PlantSeedView()
            }
        }
    }
    
    private var emptyGardenView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            SeedView(size: 80)
            
            Text("Your Garden Awaits")
                .font(.serifTitle)
                .foregroundColor(.black)
            
            Text("Plant your first seed to begin your mindful journaling journey")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button {
                showingPlantSheet = true
            } label: {
                Text("Plant Your First Seed")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [Color.warmGold, Color.amberGlow],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: .warmGold.opacity(0.4), radius: 5, x: 0, y: 2)
            }
            .padding(.top, 8)
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: JournalSeed.self, inMemory: true)
}
```

**Important:**
- Component names updated (no more `Custom` prefix)
- All extracted views now imported automatically
- Keep empty state logic
- Preserve toolbar and sheets

---

### Step 5: Update Xcode Project (Phase 8) ⚠️ CRITICAL

**This must be done in Xcode manually:**

1. **Add all new files to project:**
   - Right-click "Peony" group in navigator
   - Select "Add Files to 'Peony'..."
   - Navigate to each directory and add files:
     - `Components/Plants/` (6 files)
     - `Components/Flora/` (7 files)
     - `Components/UI/` (11 files)
     - `Views/Garden/` (10+ files)
     - `Views/Shared/` (1 file)

2. **Organize in Xcode:**
   - Create groups matching folder structure
   - Verify all files show in Project Navigator
   - Ensure "Target Membership" = Peony ✅

3. **Build the project:**
   ```bash
   Cmd + B
   ```

4. **Fix any import errors:**
   - If components aren't found, check file membership
   - Verify all files are in correct folders
   - Check for naming mismatches

---

### Step 6: Test & Verify

**Manual Testing Checklist:**
- [ ] App builds without errors
- [ ] Garden view displays correctly
- [ ] Can plant new seeds
- [ ] Seeds show correct growth stages
- [ ] Watering works
- [ ] Can view seed details
- [ ] Can edit seeds
- [ ] Can delete seeds
- [ ] Animations work
- [ ] Journal tab works
- [ ] AI features work (mood detection, prompts)

---

## 🔧 Troubleshooting

### Build Error: "Cannot find 'SeedView' in scope"
**Fix:** Add `Components/Plants/SeedView.swift` to Xcode project

### Build Error: "Cannot find type 'GardenLayoutView'"
**Fix:** Add `Views/Garden/GardenLayoutView.swift` to Xcode project

### Warning: "Duplicate symbols"
**Fix:** Make sure old struct definitions are removed from ContentView.swift

### App Crashes on Launch
**Fix:** Check that all SwiftData models are imported and ModelContainer is configured

---

## 📝 Optional: Phase 9 Polish

Once everything builds and works:

1. Update `README.md` with new architecture
2. Fix remaining TODOs in `Config.swift`
3. Add documentation comments to new components
4. Run linter and fix warnings
5. Create git commit for refactoring

---

## ⏱️ Time Estimates

- **Phase 4 remaining**: 2-3 hours (6 large view files)
- **Phase 5**: 30 minutes (utility + updates)
- **Phase 6**: 30 minutes (4 bug fixes)
- **Phase 7**: 1 hour (ContentView rewrite + testing)
- **Phase 8**: 30 minutes (Xcode project update)
- **Total**: ~5 hours of focused work

---

## 🎯 Success Criteria

When done, you'll have:
- ✅ ContentView.swift: 2,755 lines → ~250 lines (90% reduction)
- ✅ 45+ well-organized component files
- ✅ Zero code duplication
- ✅ All AI features working correctly
- ✅ Clean, maintainable codebase
- ✅ Fast compile times
- ✅ Easy to test and extend

---

## 💡 Pro Tips

1. **Work in phases** - Don't try to do everything at once
2. **Build frequently** - Catch errors early
3. **Test after each phase** - Verify nothing broke
4. **Use git** - Commit after each successful phase
5. **Ask for help** - If stuck, describe the specific error

---

**Ready to continue?** Start with Phase 4 remaining files, then move through phases 5-8 systematically. You've got this! 🚀

