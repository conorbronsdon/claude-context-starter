---
name: end
description: End a session — log what happened and update state for next time
allowed-tools: Read, Write, Edit, Glob, Bash
---

# /end — Close Session

## Instructions

### 1. Get today's date
Run `date +%Y-%m-%d` and store as TODAY.

### 2. Summarize the session
Ask the user (or infer from conversation history):
- What did we work on?
- Any decisions made?
- What's next?

### 3. Write the session log
Create or update `sessions/{TODAY}.md`:

```markdown
# Session — {TODAY}

## What happened
- [Bullet summary of work done]

## Decisions
- [Any decisions made or conclusions reached]

## Next time
- [Open threads, next actions, things to pick up]
```

If a session file already exists for today, append a new section with a timestamp header (`## Session 2 — HH:MM`) rather than overwriting.

### 4. Update state/current.md
- Update "Active priorities" if any shifted
- Add or remove "Open threads" based on what happened
- Update "Recent context" with a brief note on what was covered
- Set `**Last Updated:**` to today's date

### 5. Update state/weekly-priorities.md (if relevant)
If a priority was completed or changed, update it. Don't force an update if nothing changed.

### 6. Quick drift check

Run `git log --oneline --all --since="6 hours ago"` to check for commits from other sessions.

- If any commits touched files that were also edited in this session, flag the potential conflict to the user.
- If no parallel commits are found, skip silently — do not mention this step.
- This is a fast check, not a full `/reconcile`.

### 7. Confirm with user
Show a brief summary: "Session logged. State updated. Next priorities: [X, Y, Z]."
