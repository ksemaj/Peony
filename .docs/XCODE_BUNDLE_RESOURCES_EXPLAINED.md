# Understanding Xcode Bundle Resources

**Why JSON files need special treatment in Xcode**

---

## 📦 What is the App Bundle?

When you build an iOS app, Xcode creates a **bundle** - a special folder structure containing your compiled app and all its resources.

```
Peony.app/                    ← The app bundle
├── Peony                     ← Compiled binary (your Swift code)
├── Info.plist                ← App metadata
├── Assets.car                ← Compiled asset catalog
├── Prompts.json              ← Your JSON file (needs to be here!)
├── Frameworks/               ← Any frameworks
└── _CodeSignature/           ← Code signing data
```

---

## 🔄 The Build Process

### What Happens When You Build:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. SOURCE CODE (what you write)                            │
│                                                              │
│   Peony/                                                     │
│   ├── PromptGenerator.swift  ───┐                          │
│   ├── NotesView.swift  ──────────┼─→ Compiles to binary   │
│   ├── Models/  ──────────────────┘                         │
│   └── Prompts.json  ─────────────┐                         │
│                                    │                         │
│                                    └─→ Needs "Copy" phase   │
└─────────────────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. BUILD PHASES (what Xcode does)                          │
│                                                              │
│   ☑ Compile Sources                                        │
│   ☑ Link Binary With Libraries                             │
│   ☑ Copy Bundle Resources  ← THIS IS KEY!                  │
│   ☑ Embed Frameworks                                        │
└─────────────────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. APP BUNDLE (what gets installed)                        │
│                                                              │
│   Peony.app/                                                │
│   ├── Peony (binary)                                        │
│   ├── Prompts.json  ← Copied here if in "Copy Bundle..."  │
│   └── ...                                                    │
└─────────────────────────────────────────────────────────────┘
```

---

## ❌ Why Your JSON Wasn't Loading

### The Problem:

```
Filesystem                    Xcode Project               App Bundle
-----------                   -------------               ----------

Peony/
├── Prompts.json  ────────X   Not registered    ────X   (missing!)
└── ...
```

**Result:** `Bundle.main.url(forResource: "Prompts", withExtension: "json")` returns `nil`

---

## ✅ What We Need to Achieve

### The Solution:

```
Filesystem                    Xcode Project               App Bundle
-----------                   -------------               ----------

Peony/
├── Prompts.json  ────────→   Registered in     ────→   Prompts.json ✓
│                              project.pbxproj            (copied!)
└── ...                        
                               Listed in
                               "Copy Bundle 
                                Resources"
```

**Result:** `Bundle.main.url(forResource: "Prompts", withExtension: "json")` returns valid URL ✅

---

## 🎯 The Two Critical Steps

### Step 1: Register File in Project

**What:** Tell Xcode the file exists and belongs to the project

**How:** Right-click folder → "Add Files to 'Peony'..."

**What happens:** File reference added to `project.pbxproj`

```xml
<!-- In project.pbxproj -->
<PBXFileReference>
    <path>Prompts.json</path>
    <sourceTree>&lt;group&gt;</sourceTree>
</PBXFileReference>
```

### Step 2: Add to "Copy Bundle Resources"

**What:** Tell Xcode to copy file into app bundle during build

**How:** Target → Build Phases → Copy Bundle Resources → Add file

**What happens:** Build phase knows to copy file

```xml
<!-- In project.pbxproj -->
<PBXBuildFile>
    <fileRef>Prompts.json</fileRef>
</PBXBuildFile>
```

---

## 🔍 How Xcode Decides What to Copy

Not all files in your project get copied to the bundle!

### Files That Auto-Copy:
- ✅ `.xcassets` (asset catalogs) - always copied
- ✅ `.storyboard` - compiled and copied
- ✅ `.xib` - compiled and copied
- ✅ Localization files - copied to appropriate language folder

### Files That DON'T Auto-Copy:
- ❌ `.json` - must be explicitly added
- ❌ `.txt` - must be explicitly added  
- ❌ `.plist` (except Info.plist) - must be explicitly added
- ❌ `.csv` - must be explicitly added
- ❌ Any custom data files - must be explicitly added

---

## 🏗️ Build Phases Explained

When you select your target and go to "Build Phases", you see:

```
┌─────────────────────────────────────────────────────────────┐
│ Dependencies                                                 │
│   (Empty - no dependencies)                                  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Compile Sources                                              │
│   ├── PeonyApp.swift                                         │
│   ├── ContentView.swift                                      │
│   ├── NotesView.swift                                        │
│   ├── PromptGenerator.swift  ← Swift files compiled here   │
│   └── ... (50+ files)                                        │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Copy Bundle Resources  ← THE IMPORTANT ONE                  │
│   ├── Preview Assets.xcassets                               │
│   ├── Assets.xcassets                                        │
│   └── Prompts.json  ← MUST BE HERE!                         │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Link Binary With Libraries                                   │
│   (Frameworks get linked here)                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎨 File Reference Options Explained

When you add a file, you get these options:

### "Copy items if needed"
```
☐ Unchecked (recommended for files already in project):
  - File stays in original location
  - Xcode references it where it is
  - Changes reflect immediately
  - Better for version control

☑ Checked (for files outside project):
  - File copied into project folder
  - Original file unaffected
  - Use when importing from elsewhere
```

### "Added folders"
```
⦿ Create groups (recommended):
  - Logical organization in Xcode
  - Doesn't create real folders
  - Files appear in project navigator
  - Most flexible

○ Create folder references:
  - Blue folder in Xcode
  - Matches filesystem structure
  - Less common, usually for resources
```

### "Add to targets"
```
☑ Peony (required):
  - File belongs to this target
  - Gets compiled/copied with app
  - Must be checked!

☐ PeonyTests:
  - Only if tests need the file
  - Usually not needed for Prompts.json

☐ PeonyUITests:
  - Only if UI tests need the file
  - Usually not needed for Prompts.json
```

---

## 🧪 How Bundle.main Works

### At Runtime:

```swift
// Your code:
Bundle.main.url(forResource: "Prompts", withExtension: "json")

// What happens:
1. App launches
2. Bundle.main points to: /path/to/Peony.app/
3. Searches for: Prompts.json in that directory
4. If found: returns URL
5. If not found: returns nil
```

### The Full Path:

```
Simulator:
/Users/james/Library/Developer/CoreSimulator/Devices/
[DEVICE_UUID]/data/Containers/Bundle/Application/
[APP_UUID]/Peony.app/Prompts.json

Real Device:
/var/containers/Bundle/Application/
[APP_UUID]/Peony.app/Prompts.json
```

---

## 🔧 The verification script (`verify_bundle.sh`)

This script checks if the file made it into the bundle:

```bash
# Find where app was built
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "Peony.app")

# Check if JSON file exists in bundle
if [ -f "$APP_PATH/Prompts.json" ]; then
    echo "✅ SUCCESS! File is in bundle"
else
    echo "❌ FAILED! File is NOT in bundle"
fi
```

**Possible outcomes:**

1. **File found ✅**
   - Xcode setup is correct
   - File will load at runtime
   - App will show prompts

2. **File not found ❌**
   - Missing from "Copy Bundle Resources"
   - Need to add it to build phase
   - App will show error

---

## 🎯 Quick Reference: The Fix

### What you need to do:

```
1. Add file to project
   ├─→ Right-click "Peony" folder
   └─→ "Add Files to 'Peony'..."

2. Configure options
   ├─→ ☐ Copy items: UNCHECKED
   ├─→ ⦿ Create groups: SELECTED
   └─→ ☑ Add to targets: Peony CHECKED

3. Verify build phase
   ├─→ Select project
   ├─→ Select target
   ├─→ Build Phases tab
   └─→ "Copy Bundle Resources" contains Prompts.json

4. Clean & rebuild
   ├─→ Shift+Cmd+K (clean)
   └─→ Cmd+B (build)

5. Verify console
   └─→ Should see: "✅ Loaded 60 writing prompts from Prompts.json"
```

---

## 📊 Common Mistakes

### Mistake 1: File added as "folder reference"
```
❌ Blue folder icon in Xcode
✅ White document icon in Xcode
```

### Mistake 2: Target not checked
```
❌ File in project but not in target
✅ File checked for "Peony" target
```

### Mistake 3: Not in build phase
```
❌ File in project but not in "Copy Bundle Resources"
✅ File listed in build phase
```

### Mistake 4: Derived data corruption
```
❌ Old build cached
✅ Clean derived data, rebuild
```

---

## 💡 Pro Tips

### Tip 1: Check build logs
View the actual copy operation:
1. Build project (Cmd+B)
2. Click build status in toolbar
3. Expand "Copy Bundle Resources"
4. See: `CpResource Prompts.json`

### Tip 2: Compare working files
Look at `Assets.xcassets`:
- It's in "Copy Bundle Resources"
- It gets copied successfully
- Your `Prompts.json` should work the same way

### Tip 3: Use verification script
Instead of guessing, **verify** the file made it:
```bash
./verify_bundle.sh
```

### Tip 4: Git tracks it
Once working, `project.pbxproj` tracks the file reference:
```bash
git diff Peony.xcodeproj/project.pbxproj
```

---

## 🎉 Once It Works

### Benefits:
✅ Reliable - works every build
✅ Clean - no hardcoded data
✅ Flexible - easy to update prompts
✅ Standard - industry best practice

### Maintenance:
- Edit `Prompts.json` anytime
- No need to touch Swift code
- Just rebuild to see changes
- Git tracks content separately

---

## 🆘 Still Stuck?

1. **Check each step** in the checklist
2. **Run verification script** to diagnose
3. **Clean derived data** and rebuild
4. **Restart Xcode** (sometimes needed)
5. **Check file inspector** for file location

Remember: This is a **one-time setup**. Once it works, it works forever!

---

**Created:** October 26, 2025  
**Purpose:** Explain Xcode bundle resources for pure JSON loading  
**For:** Peony v2.5.1 - Week 2 (Writing Prompts System)


