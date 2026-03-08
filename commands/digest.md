---
name: digest
description: Synthesize session logs into patterns, stale threads, and missing decisions. Run weekly or when session history feels noisy.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# /digest — Synthesize Session Logs

## Instructions

### 1. Load recent sessions
Read the last 7 session log files from `sessions/` (sorted by date, newest first).
If fewer than 3 sessions exist, say so and offer to run with what's available.

### 2. Extract patterns

Analyze across sessions for:

- **Recurring topics:** What keeps coming up? (3+ mentions = pattern)
- **Stale threads:** Open items mentioned in early sessions but not resolved or mentioned recently
- **Missing decisions:** Questions raised but never answered; ambiguity that blocks progress
- **Completed arcs:** Things that were active and are now done — candidates for state cleanup

### 3. Route findings

| Finding | Action |
|---|---|
| Stale thread | Flag for user — suggest closing or re-prioritizing |
| Missing decision | Add to `state/blockers.md` if blocking, else flag |
| Completed arc | Suggest removing from `state/current.md` |
| Recurring topic without a skill | Suggest creating a skill or context file |

### 4. Output

```
## Digest — [DATE RANGE]

### Patterns
- [Topic] came up in 5/7 sessions — consider...

### Stale threads
- [Thread] last mentioned [DATE] — close or re-prioritize?

### Missing decisions
- [Question] raised [DATE], still open

### Completed
- [Arc] appears resolved as of [DATE] — remove from current.md?

### Suggestions
- [Actionable recommendation]
```
