# claude-context-starter

Most people paste their context into Claude's project instructions and forget about it. It goes stale. They lose track of what's there. When something changes — a new job, a new project, a new workflow — updating it means hunting through UI fields with no version history. And if you use Claude in multiple places, you're maintaining the same context in multiple places.

This repo flips that. Your context lives in files. Claude Code reads them directly; claude.ai projects read the same files as uploaded knowledge. Update a file once, and every interface you use stays current. Build a skill once — like the `avoid-ai-writing` skill included here — and it works as a slash command in Claude Code and as uploaded context in any claude.ai project.

---

## What's in here

```
CLAUDE.md                         # Main context file — who you are, slash commands, routing
ROUTING.md                        # Full context routing table for tasks without a slash command
SETUP-PROMPTS.md                  # Interactive prompts to build your context files from scratch
.mcp.json                         # Google Workspace MCP config (Drive, Gmail, Calendar, Sheets)
identity/
  who-i-am.md                    # Your bio, background, goals
  professional-background.md     # Credentials and credibility
writing/
  skills/
    avoid-ai-writing/
      SKILL.md                   # Audit content to remove AI writing patterns
projects/
  README.md                      # How to build a project section
  example-musician/              # Example: a musician's promotion workflow
    artist-context.md
    promotion-strategy.md
    skills/
      social-post/SKILL.md
      press-outreach/SKILL.md
state/
  current.md                     # Active priorities and open threads
  weekly-priorities.md           # What matters most this week
  gws-references.md              # Google Sheet/Drive IDs for live data in /start
sessions/                         # Per-day session logs (created by Claude during sessions)
commands/
  start.md                       # /start session command
  clean-ai-writing.md            # /clean-ai-writing command
references/
  gws-mcp-setup.md               # Google Workspace MCP setup guide
docs/
  migration-guide.md             # How to move from existing Claude projects into this repo
  claude-projects-sync.md        # How to keep claude.ai projects in sync with this repo
  optimizing-context.md          # Convert PDFs/docs to .md and trim files for token efficiency
```

---

## Setup

**Step 1: Clone the repo**

```bash
git clone https://github.com/conorbronsdon/claude-context-starter.git my-context
cd my-context
```

**Step 2: Install Claude Code**

```bash
npm install -g @anthropic-ai/claude-code
```

Claude Code reads `CLAUDE.md` automatically on every session start — that's how your context loads. Run it from the repo directory and it picks everything up. Full setup docs: https://docs.anthropic.com/en/docs/claude-code

**Step 3: Build your context files**

Open `SETUP-PROMPTS.md`. It has four prompts you paste into Claude Code — Claude interviews you and writes the files directly. Start with Prompt 1 (your identity) and Prompt 2 (your first project). The whole thing takes under 20 minutes and you'll have a working setup when you're done. No manual editing required.

**Step 4: Run your first session**

```bash
cd /path/to/my-context
claude
/start
```

`/start` loads your current state and any connected calendar or email data. On your first run it'll orient Claude to who you are and what's in the repo.

**Step 5: Connect your claude.ai projects**

Upload `CLAUDE.md`, `ROUTING.md`, and any relevant skill or project files to each claude.ai project as knowledge. Claude will read from the same source as Claude Code. When you update a file in the repo, re-upload it — your projects stay current with one file swap instead of rewriting system prompts.

See [docs/claude-projects-sync.md](docs/claude-projects-sync.md) for the full workflow, including which files to upload for different project types and how to use skills like `avoid-ai-writing` in claude.ai without a slash command.

**Step 6: Set up Google Workspace MCP (optional)**

Enables Claude to read your calendar, email, Drive, and Sheets mid-session — useful for the `/start` command and any task that needs live data.

```bash
npm install -g @googleworkspace/cli
gws auth setup
```

The `.mcp.json` in this repo is already configured. Claude Code picks it up automatically when you run from the repo directory. Full instructions are in `references/gws-mcp-setup.md`.

---

## How to use it day-to-day

Start every Claude Code session with `/start`. It loads your current state and surfaces what's on your plate.

Tell Claude to update files when things change:

- "Update `state/current.md` — we finished the migration, that's no longer active"
- "Add a new entry to CHANGELOG"
- "I just joined a new company — let's update `identity/who-i-am.md`"

Claude will make the edits and commit the changes. Over time, the repo becomes a running record of your context, not a snapshot that decays.

---

## Skills work everywhere

A skill is a markdown file that gives Claude specific instructions for a recurring task. Build it once and it works in every interface you use.

The `avoid-ai-writing` skill included here is a working example. In Claude Code, it runs as `/clean-ai-writing`. In a claude.ai project, you upload `writing/skills/avoid-ai-writing/SKILL.md` as knowledge and ask Claude to apply it — same behavior, no slash command needed.

When you improve the skill file, re-upload it to your claude.ai projects. One source of truth, updated in one place.

To build your own skills:

1. Create a directory under `projects/your-project/skills/your-skill-name/`
2. Add a `SKILL.md` file with instructions for the task
3. Register it as a slash command in `CLAUDE.md` for Claude Code
4. Upload the file to any claude.ai projects where you want the same behavior

The `projects/example-musician/` directory shows the full pattern with two working skills. See `projects/README.md` for the conventions. Use Prompt 3 in `SETUP-PROMPTS.md` to have Claude build a new project section interactively.

---

## Migrating from existing Claude projects

If you already have Claude projects with uploaded files and custom instructions, [docs/migration-guide.md](docs/migration-guide.md) has the full process:

- A reusable audit prompt to run in each existing project
- How to evaluate what's worth migrating vs. deleting
- How to structure what you move into this repo
- How to connect the repo to claude.ai projects going forward

---

## Contributing

This is a template, so the most useful contributions are structural — better examples, cleaner conventions, and skills that others can adapt. Open an issue if you have a pattern worth adding or a gap worth filling.
