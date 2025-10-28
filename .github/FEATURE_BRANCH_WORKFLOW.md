# 🌿 Peony Feature Branch Workflow

**Last Updated:** October 27, 2024  
**Status:** OFFICIAL WORKFLOW - Effective Immediately

---

## 🎯 Overview

This document establishes the official development workflow for Peony following the modular architecture baseline. All new features will be developed in feature branches and merged via Pull Requests.

---

## 🚀 Getting Started

### Prerequisites
- Main branch is clean and up-to-date
- You're working from the official baseline (commit `50e891f`)
- Feature branch workflow is established

### Current Baseline
- **Commit:** `50e891f` - "feat: Official baseline - Complete modular architecture refactor"
- **Date:** October 27, 2024
- **Status:** ✅ Pushed to main

---

## 📋 Feature Branch Workflow

### 1. Create Feature Branch

```bash
# Ensure you're on main and up-to-date
git checkout main
git pull origin main

# Create and switch to feature branch
git checkout -b feature/your-feature-name

# Examples:
git checkout -b feature/ai-writing-assistant
git checkout -b feature/premium-subscriptions
git checkout -b feature/plant-growth-animations
```

### 2. Development Process

#### Architecture Compliance
- **ALWAYS** follow the modular architecture rules
- Components go in `Components/`
- Views go in `Views/`
- Business logic goes in `Utilities/`
- Data models go in `Models/`
- Keep files under 600 lines (guideline)
- One file = One clear purpose

#### Development Guidelines
```bash
# Make commits frequently with clear messages
git add .
git commit -m "feat: Add AI writing prompt suggestions"
git commit -m "fix: Resolve plant growth animation timing"
git commit -m "refactor: Extract reusable button component"
```

#### Testing & Validation
- Build must succeed: `⌘+B` in Xcode
- No linter errors
- Follow SwiftUI best practices
- Maintain existing functionality

### 3. Create Pull Request

```bash
# Push feature branch
git push origin feature/your-feature-name

# Then create PR via GitHub web interface
# Or use GitHub CLI:
gh pr create --title "Feature: Your Feature Name" --body "Description of changes"
```

#### PR Requirements
- **Title:** `Feature: [Clear Description]`
- **Description:** Explain what was added/changed
- **Architecture:** Confirm compliance with modular structure
- **Testing:** Describe how you tested the changes
- **Breaking Changes:** Note any if applicable

### 4. Code Review Process

#### Reviewer Checklist
- [ ] Architecture compliance (files in correct directories)
- [ ] Code quality and readability
- [ ] No business logic in views
- [ ] Proper component extraction
- [ ] Build succeeds
- [ ] No backup files committed

#### Approval Process
- At least one approval required
- All CI checks must pass
- Architecture compliance verified
- Ready to merge

### 5. Merge to Main

```bash
# After PR approval, merge via GitHub interface
# Then update local main branch
git checkout main
git pull origin main

# Clean up feature branch
git branch -d feature/your-feature-name
git push origin --delete feature/your-feature-name
```

---

## 🏗️ Feature Branch Naming Convention

### Format: `feature/descriptive-name`

#### Examples:
- `feature/ai-writing-assistant`
- `feature/premium-subscriptions`
- `feature/plant-growth-animations`
- `feature/notification-scheduling`
- `feature/garden-layout-customization`
- `feature/journal-theme-analysis`
- `feature/water-reminder-system`

#### Guidelines:
- Use kebab-case (lowercase with hyphens)
- Be descriptive but concise
- Start with `feature/`
- Avoid abbreviations unless standard

---

## 🔄 Branch Management

### Branch Lifecycle
1. **Create** from main
2. **Develop** with regular commits
3. **Push** to origin
4. **PR** for review
5. **Merge** to main
6. **Delete** feature branch

### Branch Protection Rules
- Main branch is protected
- Requires PR for changes
- Requires review approval
- Requires CI checks to pass

---

## 📁 File Organization Reminder

### Components/ - Reusable UI Elements
```
Components/
├── Flora/          # Decorative garden elements
├── Plants/         # Plant visualizations
└── UI/            # Buttons, backgrounds, effects
    └── Toolbars/  # Toolbar-specific components
```

### Views/ - Screen-Level Components
```
Views/
├── Garden/        # Garden screen + components
├── Notes/         # Journal screen + components
├── Onboarding/   # Onboarding flow
├── Premium/      # Paywall/premium
└── Shared/       # Cross-screen utilities
    └── Layouts/  # Reusable layouts
```

### Utilities/ - Business Logic
```
Utilities/
├── AI/           # AI-specific utilities
├── Managers/     # App managers
└── Helpers/      # Helper functions
```

### Models/ - Data Layer
```
Models/
├── SwiftData models
├── Extensions
└── Configuration
```

---

## 🚨 Critical Rules

### ✅ DO
- Create feature branches for ALL new work
- Follow modular architecture strictly
- Write clear commit messages
- Test thoroughly before PR
- Keep files organized and focused
- Use descriptive branch names

### ❌ DON'T
- Work directly on main branch
- Mix multiple features in one branch
- Commit backup files (*.bak, *_OLD.swift)
- Put files in wrong directories
- Skip code review process
- Merge without approval

---

## 🔧 Quick Commands Reference

```bash
# Start new feature
git checkout main && git pull origin main
git checkout -b feature/your-feature-name

# Regular development
git add .
git commit -m "feat: Description of change"
git push origin feature/your-feature-name

# After PR merge
git checkout main
git pull origin main
git branch -d feature/your-feature-name
```

---

## 📊 Workflow Benefits

### For Development
- **Isolation:** Features don't interfere with each other
- **Review:** All changes go through code review
- **Rollback:** Easy to revert specific features
- **Collaboration:** Multiple developers can work simultaneously

### For Architecture
- **Consistency:** Enforces modular structure
- **Quality:** Maintains code standards
- **Documentation:** Clear change history
- **Maintainability:** Easier to understand and modify

---

## 🎓 Best Practices

### Commit Messages
```bash
# Good examples
git commit -m "feat: Add AI writing prompt suggestions"
git commit -m "fix: Resolve plant growth animation timing"
git commit -m "refactor: Extract reusable button component"
git commit -m "docs: Update architecture guidelines"

# Bad examples
git commit -m "fix"
git commit -m "stuff"
git commit -m "changes"
```

### PR Descriptions
```markdown
## What Changed
- Added AI writing prompt suggestions
- Enhanced plant growth animations
- Improved garden layout customization

## Architecture Compliance
- Components properly placed in Components/
- Business logic moved to Utilities/
- Views maintain single responsibility

## Testing
- Built successfully in Xcode
- Tested on iOS simulator
- Verified existing functionality works
```

---

## 🚀 Ready to Start

You're now ready to begin feature development! Remember:

1. **Always** start from main branch
2. **Always** create feature branches
3. **Always** follow modular architecture
4. **Always** create PRs for review
5. **Always** maintain code quality

Happy coding! 🌿✨

---

**Questions?** Check the architecture rules in `.cursor/commands/de-slop.md` or ask for clarification.
