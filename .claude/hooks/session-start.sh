#!/usr/bin/env bash
# session-start.sh — Advisory hook that runs when a Claude Code session starts.
# Surfaces stale files, pending inbox items, and setup reminders.
#
# Install: add to .claude/settings.local.json under hooks.SessionStart
# This hook is ADVISORY — it prints warnings but never blocks (always exits 0).

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
WARNINGS=()

# ── 1. Stale state files (not updated in 3+ days) ─────────────────────────────

STALE_DAYS=3

for f in "$REPO_ROOT"/state/*.md; do
  [ -f "$f" ] || continue
  # Extract "Last Updated:" date if present
  date_line=$(grep -i "last updated" "$f" 2>/dev/null | head -1 || true)
  if [ -n "$date_line" ]; then
    # Try to parse the date (works on macOS and Linux)
    file_date=$(echo "$date_line" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1 || true)
    if [ -n "$file_date" ]; then
      if command -v python3 &>/dev/null; then
        days_old=$(python3 -c "
from datetime import datetime
try:
    d = datetime.strptime('$file_date', '%Y-%m-%d')
    print((datetime.now() - d).days)
except:
    print(0)
" 2>/dev/null || echo 0)
        if [ "$days_old" -ge "$STALE_DAYS" ]; then
          WARNINGS+=("Stale: $(basename "$f") last updated $file_date ($days_old days ago)")
        fi
      fi
    fi
  fi
done

# ── 2. Inbox items waiting for triage ──────────────────────────────────────────

if [ -d "$REPO_ROOT/inbox" ]; then
  inbox_count=$(find "$REPO_ROOT/inbox" -type f -not -name '.gitkeep' 2>/dev/null | wc -l | tr -d ' ')
  if [ "$inbox_count" -gt 0 ]; then
    WARNINGS+=("Inbox: $inbox_count item(s) waiting for triage — run /capture")
  fi
fi

# ── 3. Overdue TODO items ─────────────────────────────────────────────────────

if [ -f "$REPO_ROOT/TODO.md" ]; then
  today=$(date +%Y-%m-%d)
  overdue=$(grep -E '\[ \].*[0-9]{4}-[0-9]{2}-[0-9]{2}' "$REPO_ROOT/TODO.md" 2>/dev/null | while read -r line; do
    due=$(echo "$line" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)
    if [ -n "$due" ] && [[ "$due" < "$today" ]]; then
      echo "  $line"
    fi
  done || true)
  if [ -n "$overdue" ]; then
    WARNINGS+=("Overdue TODOs found:\n$overdue")
  fi
fi

# ── Report ─────────────────────────────────────────────────────────────────────

if [ ${#WARNINGS[@]} -gt 0 ]; then
  echo ""
  echo "Session start notices:"
  for w in "${WARNINGS[@]}"; do
    echo -e "  ⚠ $w"
  done
  echo ""
fi

exit 0
