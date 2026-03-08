#!/usr/bin/env bash
# ssot-guard.sh — Advisory hook for PreToolUse (Edit, Write).
# Warns when editing files that are Single Source of Truth (SSOT) for specific data,
# reminding you to update the canonical location instead of duplicating facts.
#
# Customize the patterns below for your repo's SSOT rules.
# This hook is ADVISORY — it prints warnings but never blocks (always exits 0).

set -euo pipefail

# The file being edited is passed as an argument or via environment
FILE_PATH="${1:-${CLAUDE_FILE_PATH:-}}"

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# ── Define SSOT patterns ──────────────────────────────────────────────────────
# Add your own patterns here. Format: file glob → reminder message.

case "$FILE_PATH" in
  */state/current.md)
    echo "Reminder: current.md is updated by /end and /update commands. Manual edits are fine but will be overwritten next session close."
    ;;
  */state/decisions.md)
    echo "Reminder: decisions.md is append-only. Don't edit past entries — add new ones at the top."
    ;;
  # Example: protect a metrics file
  # */analytics/metrics.md)
  #   echo "Reminder: metrics.md is the SSOT for numbers. Update here, not in other docs."
  #   ;;
esac

exit 0
