---
name: start
description: Start a session — load state and get a briefing on current priorities
allowed-tools: Read, Bash, Glob, mcp__google-workspace
---

# /start — Begin Session

## Instructions

### 1. Get today's date
Run `date +%Y-%m-%d` and store as TODAY. Note the day of week.

### 2. Load context (read in order)
- `CLAUDE.md` — routing rules and slash commands
- `state/current.md` — active priorities and open threads
- `state/weekly-priorities.md` — what matters most this week
- `sessions/{TODAY}.md` — if it exists, resume today's session
- If no today file, read the most recent file in `sessions/` for continuity

### 3. Pull live data from Google Workspace (if MCP available)

If the `google-workspace` MCP server is connected, pull live context. Fall back to markdown files if not.

**Calendar — today + next 7 days:**
Use `calendar_events_list` with:
```json
{
  "calendarId": "primary",
  "timeMin": "<TODAY>T00:00:00Z",
  "timeMax": "<TODAY+7>T23:59:59Z",
  "singleEvents": true,
  "orderBy": "startTime"
}
```
Fields: `"items(summary,start,end,attendees)"` — flag anything time-sensitive in the briefing.

**Gmail — unread count (optional):**
Use `gmail_users_messages_list` with `{"userId": "me", "q": "is:unread", "maxResults": 1}` and fields `"resultSizeEstimate"`. Only mention if count is notably high.

**Project trackers (if configured):**
If you use Google Sheets to track anything (tasks, pipeline, content log), add the Sheet ID to `state/gws-references.md` and query it here. See `references/gws-mcp-setup.md` for how.

### 4. Give a briefing
Keep it short:
- Date and day of week
- Top 2-3 priorities from `state/current.md`
- Any time-sensitive open threads
- Calendar highlights for the week (from live data if available)
- Ask what to focus on today

If resuming today's session, acknowledge what was already covered and pick up from there.
