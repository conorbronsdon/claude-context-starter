# claude-context-starter

Most people paste their context into Claude's project instructions and forget about it. It goes stale. They lose track of what's there. When something changes — a new job, a new project, a new workflow — updating it means hunting through UI fields with no version history.

This repo flips that. Your context lives in files. Claude Code reads them, maintains them, and commits changes. One repo works across Claude Code, claude.ai projects, and any other interface that can read files.

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
commands/
  start.md                       # /start session command
references/
  gws-mcp-setup.md               # Google Workspace MCP setup guide
docs/
  migration-guide.md             # How to move from existing Claude projects into this repo
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

Claude Code reads `CLAUDE.md` automatically on every session start — that's how your context loads. Run it from the repo directory and it picks everything up.

**Step 3: Build your context files**

Open `SETUP-PROMPTS.md`. It has four prompts you paste into Claude Code — Claude interviews you and writes the files directly. Start with Prompt 1 (your identity) and Prompt 2 (your first project). The whole thing takes under 20 minutes and you'll have a working setup when you're done. No manual editing required.

**Step 4: Run your first session**

```bash
cd /path/to/my-context
claude
/start
```

`/start` loads your current state and any connected calendar or email data. On your first run it'll orient Claude to who you are and what's in the repo.

**Step 5: Connect to claude.ai (optional)**

If you also use claude.ai, you can sync your context there by uploading your key files as project knowledge. See [docs/migration-guide.md](docs/migration-guide.md) for the full walkthrough — including how to audit and migrate context from any existing Claude projects you already have.

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

## Building your own skills

A skill is a markdown file that gives Claude specific instructions for a recurring task. The `avoid-ai-writing` skill in this repo is a working example — it audits and rewrites content to remove AI writing patterns.

To build your own:

1. Create a directory under `projects/your-project/skills/your-skill-name/`
2. Add a `SKILL.md` file with instructions for the task
3. Register it as a slash command in `CLAUDE.md`

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
