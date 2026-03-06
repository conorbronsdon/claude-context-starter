# claude-context-starter

Most people paste their context into Claude's project instructions and forget about it. It goes stale. They lose track of what's there. When something changes — a new job, a new project, a new workflow — updating it means hunting through UI fields with no version history.

This repo flips that. Your context lives in files. Claude Code reads them, maintains them, and commits changes. One repo works across Claude Code, claude.ai projects, and any other interface that can read files.

---

## What's in here

```
CLAUDE.md                         # Main context file — who you are, slash commands, routing
ROUTING.md                        # Full context routing table for tasks without a slash command
.mcp.json                         # Google Workspace MCP config (Drive, Gmail, Calendar)
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

**Step 1: Clone and personalize**

```bash
git clone https://github.com/conorbronsdon/claude-context-starter.git my-context
cd my-context
```

Open `identity/who-i-am.md` and fill in the `[FILL IN]` placeholders. That's the only file you need to touch to get started.

**Step 2: Install Claude Code**

```bash
npm install -g @anthropic-ai/claude-code
```

Claude Code is Anthropic's terminal-based AI coding tool. It reads `CLAUDE.md` automatically on every session start, which is how your context loads. You don't need to copy anything — just run `claude` from the repo directory.

**Step 3: Run your first session**

```bash
cd /path/to/my-context
claude
/start
```

The `/start` command loads your current state and any connected calendar or email data via MCP (if configured). On your first run, it'll just orient Claude to who you are and what's in the repo.

**Step 4: Connect to claude.ai (optional)**

If you also use claude.ai's web or desktop interface, you can sync your context there by uploading your key files as project knowledge. See [docs/migration-guide.md](docs/migration-guide.md) for the full walkthrough, including how to audit and migrate context from any existing Claude projects you already have.

**Step 5: Set up Google Workspace MCP (optional)**

Enables Claude to read your calendar, email, and Drive mid-session — useful for the `/start` command and for any task that needs live data.

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
- "I just joined a new company — let's update `identity/who-i-am.md` and `career/role-context.md`"

Claude will make the edits and commit the changes. Over time, the repo becomes a running record of your context, not a snapshot that decays.

---

## Building your own skills

A skill is a markdown file that gives Claude a specific set of instructions for a recurring task. The `avoid-ai-writing` skill in this repo is a working example — it audits and rewrites content to remove AI writing patterns.

To build your own:

1. Create a directory under `projects/your-project/skills/your-skill-name/`
2. Add a `SKILL.md` file with instructions for the task
3. Register it as a slash command in `CLAUDE.md`

The `projects/example-musician/` directory shows the full pattern with two working skills. See `projects/README.md` for the conventions.

---

## Migrating from existing Claude projects

If you already have Claude projects with uploaded files and custom instructions, [docs/migration-guide.md](docs/migration-guide.md) has the full process:

- A reusable audit prompt to run in each project
- How to evaluate what's worth migrating vs. deleting
- How to structure what you move into this repo
- How to connect the repo to claude.ai projects going forward

---

## Contributing

This is a template, so the most useful contributions are structural — better examples, cleaner conventions, and skills that others can adapt. Open an issue if you have a pattern worth adding or a gap in the docs worth filling.
