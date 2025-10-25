# Peony Development Automation

This document describes the automatic synchronization between Cursor TODOs and GitHub Issues/Project Board.

## System Overview

The AI assistant automatically maintains synchronization between:
- **Cursor TODO List** - Internal task tracking during development
- **GitHub Issues** - Public issue tracker on the repository
- **GitHub Project Board** - Kanban board for visual project management

## Automatic Synchronization Rules

### When AI Starts Working on a Task

1. **Cursor:** TODO status → `in_progress`
2. **GitHub:** Issue moved to "In Progress" column
3. **GitHub:** Issue reopened if previously closed

**Example:**
```bash
# AI internally runs:
.github/sync-todos.sh start 1
```

### When AI Completes a Task

1. **Cursor:** TODO status → `completed`
2. **GitHub:** Issue closed with completion comment
3. **GitHub:** Issue moved to "Done" column
4. **GitHub:** Comment added with commit reference

**Example:**
```bash
# AI internally runs:
.github/sync-todos.sh complete 1 "abc123"
```

### When AI Creates New Tasks

1. **Cursor:** New TODO created
2. **GitHub:** New issue created automatically
3. **GitHub:** Issue added to project board
4. **GitHub:** Priority set based on task urgency
5. **Mapping:** TODO ID ↔ Issue number stored in `todo-issue-mapping.json`

**Example:**
```bash
# AI internally runs:
.github/sync-todos.sh create "Implement feature X" "Detailed description..."
```

## Project Board Columns

- **Backlog** - Future tasks, not yet ready
- **Ready** - Tasks ready to be worked on
- **In Progress** - Currently being worked on
- **In Review** - Waiting for review/testing
- **Done** - Completed tasks

## Priority Levels

- **P0** (High) - Critical features, blockers, architecture
- **P1** (Medium) - Important features, enhancements
- **P2** (Low) - Nice-to-haves, optional improvements

## Todo-Issue Mapping

The file `.github/todo-issue-mapping.json` maintains the relationship between:
- Cursor TODO IDs (e.g., `ai-architecture`)
- GitHub Issue numbers (e.g., `#1`)

This ensures the AI can always find the corresponding issue for any TODO.

## Manual Sync (If Needed)

If synchronization gets out of sync, you can manually run:

```bash
# Mark issue as in-progress
.github/sync-todos.sh start 5

# Mark issue as completed
.github/sync-todos.sh complete 5 "commit-sha"

# Create new issue
.github/sync-todos.sh create "Task title" "Task description" "P1"
```

## AI Commitment

**The AI assistant commits to:**

✅ Automatically sync ALL TODO status changes to GitHub  
✅ Create GitHub issues for new tasks without prompting  
✅ Close issues and update project board when tasks complete  
✅ Maintain todo-issue-mapping.json throughout development  
✅ Add meaningful comments and commit references to issues  
✅ Never mark a TODO as complete without closing its issue  
✅ Never start work without updating the project board  

## Benefits

- **Transparency:** All development progress visible on GitHub
- **Tracking:** Full history of what was implemented and when
- **Collaboration:** Easy for others to see what's being worked on
- **Project Management:** Visual kanban board always up-to-date
- **Zero Overhead:** No manual sync required from developer

## Files

- `.github/sync-todos.sh` - Sync automation script
- `.github/todo-issue-mapping.json` - TODO ↔ Issue mapping
- `.github/AUTOMATION.md` - This documentation

---

**Last Updated:** October 25, 2025  
**Status:** Active and Automated ✅

