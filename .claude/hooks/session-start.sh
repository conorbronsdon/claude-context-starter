#!/usr/bin/env bash
# session-start.sh — Advisory hook for session start.
# Detects first-run (unconfigured identity) and nudges toward /setup.
# This hook is ADVISORY — it prints reminders but never blocks (always exits 0).

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# Check if identity files still have placeholder content
if grep -q "\[Your Name\]" "$REPO_ROOT/CLAUDE.md" 2>/dev/null; then
  echo ""
  echo "  Looks like you haven't set up yet. Run /setup to get started."
  echo ""
else
  echo ""
  echo "  Tip: Run /start for a full session briefing."
  echo ""
fi

exit 0
