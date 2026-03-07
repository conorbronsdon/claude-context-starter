---
name: update
description: Mid-session checkpoint — save progress without ending the session
allowed-tools: Read, Write, Edit, Glob, Bash
---

# /update — Mid-Session Checkpoint

Quick state save. Use when you've made progress and want to capture it without ending the session.

## Instructions

### 1. Get today's date
Run `date +%Y-%m-%d` and store as TODAY.

### 2. Append to session log
Create or update `sessions/{TODAY}.md` with a timestamped checkpoint:

```markdown
## Checkpoint — HH:MM
- [What was done since last checkpoint or session start]
- [Any decisions or conclusions]
```

### 3. Update state/current.md
- Refresh "Recent context" with current status
- Update `**Last Updated:**` to today's date

### 4. Continue working
No need to confirm or summarize — just save and keep going. Acknowledge briefly: "Checkpoint saved."
