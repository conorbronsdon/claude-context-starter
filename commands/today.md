---
name: today
description: Morning heartbeat — briefing, deadline check, and staleness scan
allowed-tools: Read, Bash, Glob, mcp__google-workspace
---

# /today — Morning Heartbeat

Lightweight daily check-in. Run at the start of each day or after any long gap between sessions.

## Instructions

### 1. Get today's date and day of week
Run `date +%Y-%m-%d` and `date +%A`.

### 2. Load state
Read:
- `state/current.md`
- `state/weekly-priorities.md`

### 3. Check for staleness
- If `state/current.md` has `**Last Updated:**` older than 3 days, flag it
- If `state/weekly-priorities.md` has a `**Week of:**` from a previous week, flag it
- Scan any open threads in `current.md` — if an item has a date annotation older than 7 days, suggest resolving or removing it

### 4. Check recent session history
Read the most recent file in `sessions/` (if any). Note what was last worked on for continuity.

### 5. Pull live data (if MCP available)
Same as `/start` step 3 — calendar for the next 7 days, unread email count. Skip if MCP isn't connected.

### 6. Deliver the heartbeat
Keep it brief:
- Date and day of week
- Any staleness warnings (files that need updating)
- Top priorities from current.md
- Calendar highlights (if available)
- "What's the focus today?"

Do NOT re-run the full `/start` flow — this is a lighter, faster check-in.
