# Phase 2: Quick Notes (v2.0)

## Overview

Add a lightweight daily journaling mode alongside the existing seed-planting experience. Quick Notes provide instant gratification for casual reflection without the commitment of growing a seed over 45 days.

## Core Concept

**Two Journaling Modes:**

1. **Seeds** (existing) - Deep, intentional reflection that grows over time
   - Plant with title + content + optional image
   - Hidden until bloom
   - 45-day growth cycle
   - Daily watering creates streaks
   - Encourages patience & delayed gratification

2. **Quick Notes** (NEW) - Lightweight, instant daily reflection
   - Text-only, no images
   - Immediately visible (no hidden period)
   - No growth or watering
   - Quick capture of thoughts/moments
   - Encourages daily journaling habit

**Key Difference:** Seeds = deep reflection you revisit. Notes = quick capture you can read anytime.

---

## Implementation Plan

### Part 1: Data Model

#### 1.1 Create QuickNote Model

**New file: `Peony/Models/QuickNote.swift`**

```swift
import Foundation
import SwiftData

@Model
class QuickNote {
    var id: UUID
    var content: String
    var createdDate: Date
    var tags: [String] // Auto-detected or manual
    
    // Mood tracking (future AI feature)
    var detectedMood: String? // "reflective", "joyful", "thoughtful", etc.
    
    init(content: String, createdDate: Date = Date()) {
        self.id = UUID()
        self.content = content
        self.createdDate = createdDate
        self.tags = []
        self.detectedMood = nil
    }
    
    // Computed properties
    var preview: String {
        String(content.prefix(100))
    }
    
    var wordCount: Int {
        content.split(separator: " ").count
    }
}
```

#### 1.2 Update Schema

**Modify: `Peony/PeonyApp.swift`**

```swift
var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        JournalSeed.self,
        WateringStreak.self,
        QuickNote.self  // NEW
    ])
    // ... rest of configuration
}()
```

---

### Part 2: UI Architecture

#### 2.1 Main Navigation

**Update: `Peony/ContentView.swift`**

Add TabView for switching between Garden and Notes:

```swift
TabView(selection: $selectedTab) {
    // Garden Tab (existing ContentView content)
    GardenView()
        .tabItem {
            Label("Garden", systemImage: "leaf.fill")
        }
        .tag(0)
    
    // Notes Tab (NEW)
    NotesView()
        .tabItem {
            Label("Notes", systemImage: "note.text")
        }
        .tag(1)
}
```

**Design Decision:** Keep garden as default tab, notes are secondary.

#### 2.2 Notes List View

**New file: `Peony/Views/Notes/NotesView.swift`**

```swift
struct NotesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \QuickNote.createdDate, order: .reverse) private var notes: [QuickNote]
    @State private var showingCreateNote = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Same garden background as seeds
                LinearGradient(
                    colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                if notes.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(notes) { note in
                                NavigationLink {
                                    NoteDetailView(note: note)
                                } label: {
                                    NoteRowView(note: note)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingCreateNote = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.green)
                    }
                }
            }
            .sheet(isPresented: $showingCreateNote) {
                CreateNoteView()
            }
        }
    }
    
    var emptyStateView: some View {
        VStack(spacing: 20) {
            Text("📝")
                .font(.system(size: 80))
            
            Text("No notes yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Text("Quick notes are perfect for\ndaily reflections and thoughts")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Button {
                showingCreateNote = true
            } label: {
                Text("Write Your First Note")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
            }
            .padding(.top)
        }
        .padding()
    }
}
```

#### 2.3 Note Row Component

**New file: `Peony/Views/Notes/NoteRowView.swift`**

```swift
struct NoteRowView: View {
    let note: QuickNote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Date
            Text(note.createdDate, style: .date)
                .font(.caption)
                .foregroundColor(.gray)
            
            // Preview
            Text(note.preview)
                .font(.body)
                .foregroundColor(.black)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            // Metadata
            HStack {
                Text("\(note.wordCount) words")
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                Spacer()
                
                // Show mood emoji if detected
                if let mood = note.detectedMood {
                    Text(moodEmoji(mood))
                        .font(.caption)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.8))
        .cornerRadius(12)
    }
    
    func moodEmoji(_ mood: String) -> String {
        switch mood {
        case "joyful": return "😊"
        case "reflective": return "🤔"
        case "grateful": return "🙏"
        case "peaceful": return "😌"
        default: return "✨"
        }
    }
}
```

#### 2.4 Create Note View

**New file: `Peony/Views/Notes/CreateNoteView.swift`**

```swift
struct CreateNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var content = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Garden background
                LinearGradient(
                    colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Emoji indicator
                    Text("📝")
                        .font(.system(size: 60))
                        .padding(.top, 20)
                    
                    Text("Quick Note")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    // Text editor
                    ZStack(alignment: .topLeading) {
                        if content.isEmpty {
                            Text("What's on your mind?")
                                .font(.body)
                                .foregroundColor(.secondary.opacity(0.5))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 12)
                                .allowsHitTesting(false)
                        }
                        
                        TextEditor(text: $content)
                            .focused($isFocused)
                            .font(.body)
                            .foregroundColor(.black)
                            .tint(.green)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 200)
                            .padding(4)
                    }
                    .padding(8)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveNote()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(content.isEmpty ? .secondary : .green)
                    .disabled(content.isEmpty)
                }
            }
            .onAppear {
                isFocused = true
            }
        }
    }
    
    func saveNote() {
        let note = QuickNote(content: content)
        modelContext.insert(note)
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        dismiss()
    }
}
```

#### 2.5 Note Detail View

**New file: `Peony/Views/Notes/NoteDetailView.swift`**

```swift
struct NoteDetailView: View {
    let note: QuickNote
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Date
                HStack {
                    Text(note.createdDate, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(note.createdDate, style: .time)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                // Content
                Text(note.content)
                    .font(.body)
                    .foregroundColor(.black)
                
                Spacer()
                
                // Metadata card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Word count:")
                        Spacer()
                        Text("\(note.wordCount)")
                            .foregroundColor(.gray)
                    }
                    
                    if let mood = note.detectedMood {
                        HStack {
                            Text("Mood:")
                            Spacer()
                            Text(mood.capitalized)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .font(.caption)
                .foregroundColor(.black)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(12)
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.green)
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditNoteView(note: note)
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                modelContext.delete(note)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this note?")
        }
    }
}
```

#### 2.6 Edit Note View

**New file: `Peony/Views/Notes/EditNoteView.swift`**

```swift
struct EditNoteView: View {
    let note: QuickNote
    @Environment(\.dismiss) private var dismiss
    @State private var content: String
    @FocusState private var isFocused: Bool
    
    init(note: QuickNote) {
        self.note = note
        _content = State(initialValue: note.content)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("📝")
                        .font(.system(size: 60))
                        .padding(.top, 20)
                    
                    ZStack(alignment: .topLeading) {
                        if content.isEmpty {
                            Text("What's on your mind?")
                                .font(.body)
                                .foregroundColor(.secondary.opacity(0.5))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 12)
                                .allowsHitTesting(false)
                        }
                        
                        TextEditor(text: $content)
                            .focused($isFocused)
                            .font(.body)
                            .foregroundColor(.black)
                            .tint(.green)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 200)
                            .padding(4)
                    }
                    .padding(8)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .fontWeight(.semibold)
                    .disabled(content.isEmpty)
                }
            }
        }
    }
    
    func saveChanges() {
        note.content = content
        dismiss()
    }
}
```

---

### Part 3: Integration

#### 3.1 Update Main ContentView

**Modify: `Peony/ContentView.swift`**

Wrap existing content in TabView:

```swift
struct MainAppView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView() // Existing garden view
                .tabItem {
                    Label("Garden", systemImage: "leaf.fill")
                }
                .tag(0)
            
            NotesView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
                .tag(1)
        }
        .tint(.green)
    }
}
```

**Update PeonyApp.swift to use MainAppView instead of ContentView.**

#### 3.2 Cross-Linking (Optional Enhancement)

Add ability to reference notes from seeds or vice versa:

- "View related notes" button in SeedDetailView
- "Plant as seed" button in NoteDetailView (convert note → seed)

---

### Part 4: Polish & UX

#### 4.1 Statistics

**New: NotesStatsView** (accessible from NotesView toolbar)

- Total notes written
- Longest streak of daily notes
- Most productive month
- Word count trends

#### 4.2 Search & Filter

Add to NotesView toolbar:
- Search by content
- Filter by date range
- Filter by mood (future AI feature)

#### 4.3 Animations

- Smooth transitions between tabs
- Note creation success animation
- Swipe to delete in list

---

## Files to Create

1. **Models:**
   - `Peony/Models/QuickNote.swift`

2. **Views:**
   - `Peony/Views/Notes/NotesView.swift` (main list)
   - `Peony/Views/Notes/NoteRowView.swift` (list item)
   - `Peony/Views/Notes/CreateNoteView.swift` (new note)
   - `Peony/Views/Notes/NoteDetailView.swift` (view note)
   - `Peony/Views/Notes/EditNoteView.swift` (edit note)

3. **Main:**
   - `Peony/Views/MainAppView.swift` (tab container)

## Files to Modify

1. `Peony/PeonyApp.swift` - Update schema, use MainAppView
2. `Peony/Models/Config.swift` - Add Quick Notes config
3. `Peony/ContentView.swift` - Extract to GardenView component

---

## Implementation Order

### Phase 2.1: Foundation (Day 1)
1. ✅ Create QuickNote model
2. ✅ Update PeonyApp schema
3. ✅ Create MainAppView with TabView
4. ✅ Basic NotesView (empty state)

### Phase 2.2: Core Features (Day 2)
5. ✅ CreateNoteView with TextEditor
6. ✅ NoteRowView component
7. ✅ Note list with SwiftData query
8. ✅ Save/delete functionality

### Phase 2.3: Details (Day 3)
9. ✅ NoteDetailView
10. ✅ EditNoteView
11. ✅ Navigation & routing
12. ✅ Toolbar actions

### Phase 2.4: Polish (Day 4)
13. ✅ Animations & transitions
14. ✅ Empty states
15. ✅ Error handling
16. ✅ Testing

---

## Design Principles

**1. Complementary, Not Competitive**
- Seeds = long-term, intentional
- Notes = quick, spontaneous
- Both serve different needs

**2. Consistent Visual Language**
- Same garden background
- Same color palette
- Same typography
- Familiar UI patterns

**3. Low Friction**
- Quick access to create note
- No required fields beyond content
- Auto-save on background
- Fast navigation

**4. Future-Proof**
- Structure supports AI features
- Ready for mood detection
- Can add tags/categories
- Export capability foundation

---

## Future Enhancements (v2.1+)

**Smart Features:**
- Auto-detect mood from content (Core ML)
- Suggest converting note → seed
- Daily note prompts
- Note-to-seed relationships

**Organization:**
- Tags/categories
- Favorites
- Archive old notes
- Bulk operations

**Insights:**
- Writing streak tracking
- Word count trends
- Most active times
- Mood patterns over time

---

## Success Metrics

**User Engagement:**
- % users who try Quick Notes
- Average notes per week
- Notes vs Seeds ratio
- Retention after adding notes

**Usage Patterns:**
- When do users write notes? (vs seeds)
- How long are notes typically?
- Do users edit notes?
- Do notes lead to more seeds?

---

## To-Dos

### Phase 2.1: Foundation
- [ ] Create QuickNote.swift model
- [ ] Update PeonyApp schema
- [ ] Create MainAppView with TabView
- [ ] Implement basic NotesView structure
- [ ] Add empty state UI

### Phase 2.2: Core CRUD
- [ ] Build CreateNoteView with TextEditor
- [ ] Implement save note functionality
- [ ] Create NoteRowView component
- [ ] Build notes list with SwiftData query
- [ ] Add delete functionality

### Phase 2.3: Details & Navigation
- [ ] Implement NoteDetailView
- [ ] Build EditNoteView
- [ ] Add navigation between views
- [ ] Implement menu actions (edit/delete)
- [ ] Add confirmation dialogs

### Phase 2.4: Polish
- [ ] Add animations and transitions
- [ ] Implement haptic feedback
- [ ] Polish empty states
- [ ] Add error handling
- [ ] Test on different devices
- [ ] Update README documentation

