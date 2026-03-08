---
name: reconcile
description: Scan for multi-session drift and SSOT violations. Run after parallel Claude Code sessions or when something feels off.
allowed-tools: Read, Glob, Grep, Bash
---

# /reconcile — Drift Detection

## Instructions

### 1. Check for divergence

Run these checks in parallel:

**Git state:**
- `git status` — any uncommitted changes?
- `git stash list` — any forgotten stashes?
- `git branch` — any lingering worktree branches that should have been merged?

**SSOT violations:**
- Scan for duplicate facts: same metric, date, or status appearing in multiple files
- Check that `state/current.md` priorities align with `state/weekly-priorities.md`
- Check that `TODO.md` tasks don't contradict `state/blockers.md`

**Staleness:**
- Any `**Last Updated:**` dates older than 7 days in state files?
- Any session logs from today that weren't reflected in state files?

### 2. Report findings

```
## Reconcile — [DATE]

### Git
- [Clean / uncommitted changes / stale branches]

### SSOT
- [Any duplicate facts or contradictions found]

### Staleness
- [Files that need updating]

### Actions taken
- [What was fixed automatically, if anything]

### Needs your input
- [Anything that requires a human decision]
```

### 3. Auto-fix (with confirmation)
If safe fixes are obvious (e.g., updating a stale date, removing a resolved blocker), suggest them and ask for confirmation before applying.
