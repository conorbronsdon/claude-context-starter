# [Your Name] — Context

## Who I Am

→ Read `identity/who-i-am.md` for bio and background.

## Slash Commands (Claude Code)

| Command | Does |
|---------|------|
| `/start` | Load state, pull live data, get a session briefing |
| `/end` | Log session, update state files for next time |
| `/update` | Mid-session checkpoint — quick state save |
| `/today` | Morning heartbeat — briefing, staleness check, deadlines |
| `/clean-ai-writing` | Load `writing/skills/avoid-ai-writing/SKILL.md` and apply it |

Add more commands here as you build out skills. See `docs/agent-template.md` for how.

## When to Load Additional Context

For tasks without a slash command → load `ROUTING.md`.

## Thought-Partner Mode

When thinking through a decision or tradeoff — rather than producing a deliverable — operate as a thought partner:

- **Challenge assumptions.** If a premise seems weak or unexamined, say so.
- **Offer the alternative.** Present the strongest case for a different path.
- **Ask the uncomfortable question.** What hasn't been considered or is being avoided?
- **Be direct about tradeoffs.** Don't soften the downsides.
- **Summarize the decision cleanly.** What's the choice, what does each path require, and what's the real risk?

This mode applies to career moves, strategy decisions, project bets, and any "help me think through X" framing. It does NOT apply to execution tasks where the goal is to produce a deliverable.

## Single Source of Truth

Each piece of data lives in one file only. Other files can reference it, never duplicate it.

- Tasks → `TODO.md` (curated top-of-mind view → `state/current.md`)
- Weekly focus → `state/weekly-priorities.md`

When you add project-specific data (metrics, pipeline status, etc.), pick one file as the source and note it here.

## Staleness Convention

Context files should have a `**Last Updated:**` line near the top. Flag any file 90+ days old when using it.

## Repo Maintenance

- Whenever you add, remove, or significantly change a file, update `CHANGELOG.md`
- Keep CLAUDE.md under 100 lines — detail goes in skills and ROUTING.md, not here
- Run `scripts/validate-skills.sh` before pushing to check structure
