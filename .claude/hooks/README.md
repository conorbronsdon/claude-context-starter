# Claude Code Hooks

These scripts run automatically during Claude Code sessions. They are **advisory** — they print warnings but never block actions.

## Files

| Hook | Event | Purpose |
|------|-------|---------|
| `session-start.sh` | `SessionStart` | Surfaces stale state files, inbox items, overdue TODOs |
| `ssot-guard.sh` | `PreToolUse` (Edit/Write) | Warns when editing SSOT files to prevent fact duplication |

## Configuration

Hooks are configured in `.claude/settings.local.json`. See the example file in this directory or the [Claude Code docs](https://docs.anthropic.com/en/docs/claude-code/hooks) for details.

### Example settings.local.json

```json
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "bash .claude/hooks/session-start.sh"
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "type": "command",
        "command": "bash .claude/hooks/ssot-guard.sh \"$CLAUDE_FILE_PATH\""
      }
    ]
  }
}
```

## Customizing

- Edit the stale-days threshold in `session-start.sh` (default: 3 days)
- Add your own SSOT patterns in `ssot-guard.sh`
- Create new hooks for other events (`PreToolUse`, `PostToolUse`, etc.)
