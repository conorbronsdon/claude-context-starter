# claude-context-starter

Most people paste their context into Claude's project instructions and forget about it. It goes stale. They lose track of what's there. When something changes — a new job, a new project, a new workflow — updating it means hunting through UI fields with no version history. And if you use Claude in multiple places, you're maintaining the same context in multiple places.

This repo flips that. Your context lives in files. Claude Code reads them directly; claude.ai projects read the same files as uploaded knowledge. Update a file once, and every interface you use stays current. Build a skill once — like the `avoid-ai-writing` skill included here — and it works as a slash command in Claude Code and as uploaded context in any claude.ai project.

---

## Quick start

```bash
git clone https://github.com/conorbronsdon/claude-context-starter.git my-context
cd my-context
bash scripts/setup.sh
```

The setup script walks you through the basics: sets your name, swaps the git remote to your own repo, installs hooks, and offers to launch Claude Code. If you don't have Claude Code yet:

```bash
npm install -g @anthropic-ai/claude-code
```

Once you're in Claude Code, run:

```
/setup
```

Claude interviews you and builds your context files — identity, first project, weekly priorities. Takes about 10 minutes. No manual editing required.

**Using claude.ai instead?** Open `SETUP-PROMPTS.md` and paste the prompts there — same questions, same results, you just copy the output into files manually.

---

## After setup

Run your first session:

```bash
cd /path/to/my-context
claude
/start
```

`/start` loads your state and gives you a briefing. At the end of your session, run `/end` to log what happened. That's the core loop — `/start` → work → `/end`.

| Command | When | What it does |
|---------|------|-------------|
| `/setup` | First time | Interactive onboarding — builds all your context files |
| `/start` | Beginning of session | Loads state, pulls live data, gives you a briefing |
| `/update` | Mid-session | Quick checkpoint — saves progress without closing |
| `/end` | End of session | Logs what happened, updates state for next time |
| `/today` | Start of day | Lighter heartbeat — staleness check, calendar, priorities |
| `/capture` | When inbox has items | Triages raw notes from `inbox/` into the right files |
| `/context` | Any time | Finds relevant context files by topic keyword |
| `/reconcile` | After parallel work | Detects drift between sessions, SSOT violations |
| `/content-shipped` | After publishing | Logs a published piece to `content/log.md` |

---

## What's in the repo

```
CLAUDE.md                         # Root context — loaded on every session
ROUTING.md                        # Context routing for tasks without a slash command
TODO.md                           # Task backlog
SETUP-PROMPTS.md                  # Setup prompts for claude.ai users
identity/                         # Your bio, background, goals
projects/                         # Project context and skills (with worked example)
writing/skills/                   # Writing skills (avoid-ai-writing included)
state/                            # Session state, priorities, decisions, blockers
sessions/                         # Per-day session logs (created by /end)
inbox/                            # Drop zone for raw notes (triaged by /capture)
content/log.md                    # Published content log
commands/                         # Slash command definitions (including /setup onboarding)
scripts/                          # Setup, validation, repo map generation
docs/                             # Architecture guides, migration, safety contract
references/                       # Integration setup (Google Workspace, Notion)
.claude/hooks/                    # Session start + SSOT guard hooks
.github/                          # CI validation + PR template
```

---

## Skills work everywhere

A skill is a markdown file that tells Claude how to do a recurring task. Build it once and it works as a slash command in Claude Code and as uploaded knowledge in claude.ai.

The `avoid-ai-writing` skill is included as a working example. In Claude Code: `/clean-ai-writing`. In claude.ai: upload `writing/skills/avoid-ai-writing/SKILL.md` as project knowledge and ask Claude to apply it.

To build your own:

1. Read `docs/agent-template.md` for the scaffold
2. Create `projects/your-project/skills/your-skill-name/SKILL.md`
3. Add a command file in `commands/` and a row in `CLAUDE.md`
4. Run `scripts/validate-skills.sh` to verify

See `projects/README.md` for conventions and the example musician project for the full pattern.

---

## Optional integrations

**Google Workspace MCP** — lets Claude read your calendar, email, Drive, and Sheets mid-session:

```bash
npm install -g @googleworkspace/cli
gws auth setup
```

The `.mcp.json` is already configured. See `references/gws-mcp-setup.md` for details.

**claude.ai sync** — upload `CLAUDE.md`, `ROUTING.md`, and relevant skill files to claude.ai projects as knowledge. See `docs/claude-projects-sync.md` for the workflow.

---

## Validation

```bash
bash scripts/validate-skills.sh
```

Checks for: missing frontmatter, CLAUDE.md over 100 lines, committed secrets, stale files (90+ days).

---

## Key conventions

- **Single source of truth:** Each fact lives in one file. Others reference, never duplicate.
- **CLAUDE.md stays small:** Under 100 lines. Detail goes in skills and ROUTING.md.
- **Staleness dates:** `**Last Updated:**` near the top of context files. Validation flags 90+ days.
- **TODO.md vs. current.md:** TODO is the full backlog; `state/current.md` is the top-of-mind view.

---

## Migrating from existing Claude projects

See [docs/migration-guide.md](docs/migration-guide.md) — includes an audit prompt, evaluation criteria, and restructuring guide.

---

## Contributing

This is a template — the most useful contributions are structural: better examples, cleaner conventions, and skills others can adapt. Open an issue if you have a pattern worth adding.
