---
name: capture
description: Triage raw notes from inbox/ into the correct repo locations. Use when you drop unstructured content and need it routed.
allowed-tools: Read, Write, Edit, Glob, Bash
---

# /capture — Triage Inbox

## Instructions

### 1. Scan inbox
Read every file in `inbox/`. If the directory is empty, say so and stop.

### 2. For each item, determine its type and destination

| Content type | Destination | Action |
|---|---|---|
| Task / TODO | `TODO.md` | Append to appropriate section |
| Decision or conclusion | `state/decisions.md` | Add as new entry (newest first) |
| Blocker | `state/blockers.md` | Add with context |
| Priority change | `state/current.md` | Update priorities |
| Writing idea or draft | `inbox/` (keep) or project skill dir | Move if ready, keep if raw |
| Reference link or note | Relevant context file | Append to appropriate section |
| Unknown | Ask user | Don't guess — ask where it goes |

### 3. Route each item
- Move content to its destination file
- Delete the inbox file after routing (or move to a project-specific location)
- If an item is ambiguous, ask the user before routing

### 4. Report
Summarize what was routed and where:
```
Captured 3 items:
  → TODO.md: "Set up monitoring dashboard"
  → state/decisions.md: "Chose Postgres over MongoDB"
  → state/blockers.md: "Waiting on API access from vendor"
```
