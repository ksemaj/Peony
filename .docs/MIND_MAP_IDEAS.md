# Mind Map Feature Ideas 🧠

**Target Version:** v3.0+
**Status:** Conceptual - for future exploration

## Vision

Add a visual mind mapping feature to help users discover connections between their thoughts, track how ideas evolve over time, and understand patterns in their reflections.

## Core Concept

Transform journaling from linear entries into a **connected graph of thoughts**, where users can see how their reflections relate, branch, and evolve.

---

## Option A: "Thought Threads"

### Concept
Journal entries can spawn "related thoughts" creating branching conversation threads with yourself.

### Features
- **Branch Creation:** Any entry can create a "related thought"
- **Visual Tree:** See how one reflection led to another over time
- **Link Prompts:** "This reminds me of..." creates connection between entries
- **Thread View:** Follow a single thought thread from start to present

### UI
```
Entry: "Feeling anxious about work"
  ├─ "Why the anxiety? (3 days later)"
  │   └─ "Realized it's about control" (1 week later)
  └─ "Had similar feelings before..." (links to old entry)
```

### Best For
- Following thought evolution
- Understanding how you work through problems
- Seeing personal growth over time

---

## Option B: "Memory Garden Graph"

### Concept
Transform the garden metaphor into a 3D space where proximity indicates relatedness.

### Features
- **Unified Visualization:** Seeds and Journal entries both become nodes
- **Seeds = Deep Roots:** Central themes that grow slowly, anchor the graph
- **Journal = Daily Connections:** Quick thoughts that connect to seeds
- **Spatial Clustering:** Related entries naturally cluster together
- **Growth Over Time:** Watch your garden of thoughts expand

### UI
- 3D or 2D graph view with pan/zoom
- Tap node to read entry
- Lines show connections
- Color = mood/category
- Size = importance/length/engagement

### Best For
- Visual thinkers
- Discovering unexpected connections
- Beautiful, engaging visualization

---

## Option C: "Context Layers"

### Concept
Automatic theme detection creates contextual layers showing how topics intersect.

### Features
- **Auto-Tagging:** AI detects contexts (work, relationships, growth, health, etc.)
- **Intersection View:** See when contexts overlap ("When I write about work, I mention stress")
- **Pattern Recognition:** "You often reflect on relationships after work entries"
- **Context Timeline:** Track how much you write about each context over time

### UI
```
[Work] ←→ [Stress] ←→ [Health]
   ↓                      ↓
[Career]              [Exercise]
   ↓                      ↓
[Goals] ←────────────────┘
```

### Best For
- Understanding life balance
- Identifying what drives certain feelings
- Seeing how areas of life connect

---

## Option D: "Branching Seeds"

### Concept
Seeds can sprout multiple branches (follow-up reflections), creating a tree of related deep thoughts.

### Features
- **Parent-Child Seeds:** Any seed can have follow-up seeds
- **Branch Visualization:** See how one deep thought spawned others
- **Multi-Generation Growth:** Grandchild seeds referencing original insights
- **Journal → Seed Promotion:** Meaningful journal entries "graduate" to seeds

### UI
```
🌸 Original Seed: "What is happiness?"
 ├─ 🌺 "Maybe it's acceptance"
 │   └─ 🌱 "Practicing gratitude daily" (growing)
 └─ 🌺 "Connection with others"
     └─ 🌱 "Vulnerability is strength" (growing)
```

### Best For
- Deep, philosophical journaling
- Long-term thought evolution
- Meaningful insight tracking

---

## Technical Considerations

### Data Model Changes
```swift
// Add relationship support
struct ThoughtConnection {
    let fromEntry: UUID
    let toEntry: UUID
    let relationshipType: ConnectionType
    let createdAt: Date
    let userNote: String? // Why they're connected
}

enum ConnectionType {
    case related       // "This reminds me of..."
    case followUp      // "Continuing this thought..."
    case contrasts     // "Changed my mind from..."
    case inspiredBy    // "This made me think about..."
}

// Update models
extension JournalEntry {
    var connections: [ThoughtConnection] { get }
}

extension JournalSeed {
    var parentSeed: UUID?
    var childSeeds: [UUID] { get }
}
```

### Visualization Libraries
- **SwiftUI native:** Custom graph with `Canvas` or `GeometryReader`
- **Third-party:** Consider force-directed graph libraries
- **3D option:** SceneKit for 3D garden view

### Performance
- Lazy loading for large graphs (100+ entries)
- Pagination for connection queries
- Cache frequently accessed connections

---

## Implementation Phases

### Phase 1: Basic Linking (v3.0)
- Add "Link to entry" button in detail view
- Simple list showing connected entries
- Manual connections only

### Phase 2: Visual Graph (v3.1)
- 2D graph visualization
- Pan/zoom navigation
- Filter by date range or mood

### Phase 3: Smart Suggestions (v3.2)
- AI suggests potential connections
- "Entries similar to this one..."
- Auto-detect themes across connected entries

### Phase 4: Advanced Features (v3.3+)
- 3D visualization option
- Export mind map as image
- Share connected thought threads
- Time-lapse animation of graph growth

---

## Open Questions

1. **Cognitive Load:** Will users actually link entries, or is it too much friction?
2. **Discovery:** How do users find old entries to link to? (Need good search)
3. **Value Prop:** What's the compelling reason to use mind map vs. just reading old entries?
4. **Simplicity:** Does this fit Peony's "mindful simplicity" philosophy?
5. **Mobile UX:** Can graph navigation feel good on a small screen?

---

## Alternative: Start Simpler

Instead of full mind map, consider:

### "Related Entries" Card
- At bottom of each entry detail view
- "Entries that mention similar themes"
- Automatic, no user action needed
- Tap to jump to related entry
- Low friction, high value

### "Thought Paths"
- Chronological view with theme highlighting
- "Follow the 'growth' theme through your journal"
- Linear (easier on mobile) but shows connections
- Like a filtered timeline with context

---

## Next Steps (When Ready)

1. **User Research:** Would users actually use this? Ask beta testers
2. **Prototype:** Build quick mockup in Figma/Sketch
3. **Start Small:** Implement "Related Entries" card first
4. **Test & Iterate:** See if users engage before building full graph
5. **Technical Spike:** Test graph rendering performance with 500+ entries

---

## References & Inspiration

- **Obsidian:** Graph view for connected notes
- **Roam Research:** Bidirectional linking
- **TheBrain:** Mind mapping with spatial navigation
- **Notion:** Database relations and backlinks
- **Apple Notes:** Links between notes (simple but effective)

---

**Remember:** Peony's strength is simplicity and beauty. Mind map should enhance reflection, not complicate it. Start with the simplest version that adds real value.
