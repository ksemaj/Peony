# 🏛️ Peony Architecture Rules - STRICTLY ENFORCED

**Last Updated:** October 27, 2024  
**Status:** MANDATORY - No Exceptions Without Explicit Approval

---

## 🚨 CRITICAL RULES - NEVER VIOLATE

### Rule 1: Work in the Right Place
- **Know where you're working and why**
- Views go in `Views/`, components in `Components/`, utilities in `Utilities/`
- If you're editing a file, you should know its purpose and location
- Don't create files in random places

### Rule 2: File Size - Practical Limits
- **Maximum 400-500 lines per file** (guideline, not law)
- If a file is hard to navigate or understand, split it
- Size is a symptom, not the problem
- Exception: Complex views can be larger if well-organized

### Rule 3: Single Responsibility 
- **One file = One clear purpose**
- No "kitchen sink" files with multiple unrelated structs
- If you use "and" to describe a file's purpose, consider splitting
- But don't split just to split - practical > academic

### Rule 4: Directory Structure is Sacred
```
Peony/
├── PeonyApp.swift (ONLY FILE IN ROOT)
├── Models/           (Data models, extensions)
├── Utilities/        (Business logic, managers)
│   └── AI/          (AI-specific utilities)
├── Components/       (Reusable UI components)
│   ├── Plants/      (Plant visualizations)
│   ├── Flora/       (Decorative elements)
│   └── UI/          (Buttons, backgrounds, effects)
│       └── Toolbars/
├── Views/            (Screen-level views)
│   ├── Garden/      (Garden screen + components)
│   ├── Notes/       (Journal screen + components)
│   ├── Onboarding/  (Onboarding flow)
│   ├── Premium/     (Paywall/premium)
│   └── Shared/      (Cross-screen utilities)
│       └── Layouts/ (Reusable layouts)
└── Assets/           (Images, fonts, etc)
```

### Rule 5: Import Management
- Never use wildcard imports
- Only import what you need
- Common imports by file type:
  - Views: `SwiftUI`
  - Models: `Foundation`, `SwiftData`
  - Utilities: `Foundation` (no SwiftUI)

---

## 📁 File Placement Rules

### Components/ - Reusable UI Elements
✅ **Belongs here:**
- Buttons, cards, badges
- Animations, effects
- Plant/flora visualizations
- Background elements
- No business logic
- Stateless when possible

❌ **Does NOT belong:**
- Complete screens
- Navigation logic
- Data fetching
- Business logic

### Views/ - Screen-Level Components
✅ **Belongs here:**
- Full screens (tabs, modals)
- Screen-specific components
- Navigation structure
- Sheet presentations

❌ **Does NOT belong:**
- Reusable components (goes to Components/)
- Business logic (goes to Utilities/)
- Data models (goes to Models/)

### Utilities/ - Business Logic
✅ **Belongs here:**
- Managers (NotificationManager, etc.)
- Helper functions
- API clients
- Data processing
- Pure Swift code

❌ **Does NOT belong:**
- UI code
- SwiftUI views
- View models (unless extracted for reuse)

### Models/ - Data Layer
✅ **Belongs here:**
- SwiftData models
- Enums, structs for data
- Extensions for Colors, Fonts
- Configuration constants

❌ **Does NOT belong:**
- UI logic
- View code
- Business logic

---

## 🔧 Component Extraction Rules

### When to Extract a Component

**Extract when it makes sense:**
1. Component is reused in 2+ places (definitely extract)
2. Component has complex logic that clutters parent view
3. You're struggling to find something in a file
4. It would genuinely improve readability

**Don't extract just because:**
- "It's 50 lines" (so what? Is it clear?)
- "The rules say so" (rules serve you, not vice versa)
- "It might be reusable someday" (YAGNI - extract when you need it)

**Extraction Process:**
1. Create new file in appropriate directory
2. Move component code
3. Add imports
4. Add `#Preview` if useful
5. Update original file to use new component
6. Verify build

### Naming Conventions

**Files:**
- PascalCase: `GardenToolbarButtons.swift`
- Descriptive: Name tells you exactly what it is
- No abbreviations unless standard (UI, AI)

**Structs/Classes:**
- Match filename: `struct GardenToolbarButtons`
- Suffix with type: `View`, `Manager`, `Model`

**Functions:**
- camelCase: `sendTestNotification()`
- Verb-noun: Action first

---

## 🚫 Anti-Patterns - NEVER DO THESE

### ❌ Monolithic Files
```swift
// BAD: 500 line ContentView with everything
struct ContentView: View {
    // 200 lines of state
    // 100 lines of helper functions
    // 200 lines of subviews
}
```

### ❌ Multiple UNRELATED Components Per File
```swift
// BAD: These have nothing to do with each other
struct UserProfile: View { }
struct WeatherWidget: View { }
struct PaymentButton: View { }
```

```swift
// OKAY: These are related and work together
struct ThemesCard: View { }
private struct ThemeChip: View { } // Helper for ThemesCard
```

### ❌ Business Logic in Wrong Place
```swift
// BAD: API calls and data processing in a view
var body: some View {
    let result = await networkCall()
    let processed = complexCalculation(result)
    return Text(processed)
}

// GOOD: Logic in proper utility
var body: some View {
    Text(DataProcessor.shared.getProcessedData())
}
```

### ❌ Backup Files in Repo
```swift
// BAD: Never commit these
ContentView.swift.bak
ContentView_OLD.swift
ContentView_NEW.swift
```

---

## ✅ Best Practices

### State Management
- Use `@State` for local view state
- Use `@Binding` to pass state down
- Use `@Environment` for shared data
- Use `@AppStorage` for user preferences
- Keep state as close as possible to where it's used

### Async Operations
- Always handle on correct thread
- Set UI state synchronously (not in Task)
- Background work in Task
- Use `MainActor.run` only when necessary

### Component Communication
```swift
// GOOD: Props down, events up
struct ChildView: View {
    let data: String           // Props down
    let onTap: () -> Void     // Events up
}
```

### Code Organization Within Files
```swift
// GOOD: Organized structure
struct MyView: View {
    // MARK: - Properties
    @State private var value: String
    
    // MARK: - Body
    var body: some View { }
    
    // MARK: - Computed Properties
    private var formattedValue: String { }
    
    // MARK: - Helper Functions
    private func helper() { }
}

// MARK: - Preview
#Preview { }
```

---

## 🎯 Architecture Checklist

Before committing code, verify:

- [ ] **Files are in the RIGHT directories** (most important!)
- [ ] Each file has one clear purpose
- [ ] No backup files (*.bak, *_OLD.swift)
- [ ] No empty directories
- [ ] Business logic is in Utilities/, not scattered in views
- [ ] Code is organized and findable
- [ ] Build succeeds
- [ ] You understand what you changed and where

---

## 📊 Metrics to Track

### File Organization Health
- **Green:** Clear purpose, easy to navigate, in right directory
- **Yellow:** Getting cluttered, hard to find things, purpose unclear
- **Red:** Total chaos, multiple responsibilities, wrong location

### Component Extraction
- If used once: Keep inline (unless it clutters)
- If used twice: Consider extracting (is it clearer?)
- If used 3+: Probably extract to Components/

### Directory Depth
- Maximum 3 levels deep (usually)
- Example: `Views/Shared/Layouts/` ✅
- Example: `Views/Shared/Layouts/Custom/Special/` ❌ (excessive)

---

## 🔨 Enforcement

### AI Assistant Rules
1. **Always check file size** before editing
2. **Extract components** proactively (don't wait to be asked)
3. **Respect directory structure** - never put files in wrong place
4. **No shortcuts** - proper modularity every time
5. **Question unclear requirements** - better to ask than violate rules

### Human Developer Rules
1. Review this document monthly
2. Refactor any file approaching 200 lines
3. No "I'll clean it up later" - enforce now
4. Code reviews check architecture compliance
5. Update this document when patterns emerge

---

## 📚 Quick Reference

| Need | Goes Here | Size Guideline |
|------|-----------|----------------|
| Button component | `Components/UI/` | Keep reasonable |
| Screen view | `Views/{Feature}/` | 400-500 lines okay |
| Business logic | `Utilities/` | As needed |
| Data model | `Models/` | As needed |
| Layout helper | `Views/Shared/Layouts/` | Keep focused |

---

## 🎓 Philosophy

**"Know where you are, know what you're doing"**

- File purpose should be obvious from location and name
- If you can't find something quickly, organization is wrong
- When in doubt, ask: "Is this in the right place?"
- Practical > Perfect
- Clean, organized code > Academic modularity

---

**Remember:** The refactor was about making code WORKABLE, not creating bureaucracy.

**Real Problems (Fix These):**
- Files in wrong directories
- Backup files in repo
- Business logic scattered in views
- Can't find what you're looking for

**Not Real Problems (Don't Obsess):**
- "This file is 250 lines" (so what? Is it clear?)
- "Should I split this 40-line component?" (probably not)
- "The rules say 200 lines max" (rules are guidelines)

**Key Question:** Is the code organized, clean, and easy to work with? If yes, you're good.

