# Sessions

This directory holds per-day session notes. The `/start` command checks for a file matching today's date — if one exists, it resumes from where you left off. If not, it reads the most recent file for continuity.

## Format

Files are named `YYYY-MM-DD.md`. Claude Code creates and updates them during sessions when you ask it to log what you worked on.

## Example

Ask Claude at the end of a session:

```
Log today's session — what we worked on, decisions made, and what's next.
```

It will create or update `sessions/YYYY-MM-DD.md` with a brief summary. The next time you run `/start`, it reads that file and picks up the thread.

## What to put in a session file

Keep it short. The goal is continuity across sessions, not a full journal:
- What you worked on
- Decisions made or conclusions reached
- Open threads and next actions
- Anything Claude should remember coming in next time

## This directory in git

Session files are personal and often contain work-in-progress notes. You may want to add `sessions/` to `.gitignore` if you'd rather not commit them. The `.gitkeep` file is just here to preserve the directory in the repo.
