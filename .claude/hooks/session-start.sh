#!/usr/bin/env bash
# session-start.sh — Minimal advisory hook for session start.
# Full checks (stale files, inbox, overdue TODOs) are handled by /start.
#
# Install: add to .claude/settings.local.json under hooks.SessionStart
# This hook is ADVISORY — it prints a reminder but never blocks (always exits 0).

echo ""
echo "  Tip: Run /start for a full session briefing (state, calendar, staleness checks)."
echo ""

exit 0
