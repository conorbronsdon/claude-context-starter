# claude-context-starter

A personal context repo template for Claude Code. Instead of managing stale project files in claude.ai, keep your context version-controlled here — Claude Code reads it, keeps it updated, and pulls live data from your tools via MCP.

## The idea

Most people paste their context into Claude's project instructions and forget about it. It goes stale. You lose track of what's there. When you want to update it, you're doing it manually.

This repo flips that. Claude Code reads your context from files it can actually maintain. You update them in conversation, Claude commits the changes, and everything stays fresh. One repo works across Claude Code, claude.ai projects, and any other interface that can read files.

## What's in here

```
CLAUDE.md                    # Main context file — who you are, slash commands, routing
ROUTING.md                   # Full context routing table for tasks without a slash command
.mcp.json                    # Google Workspace MCP config (Drive, Gmail, Calendar, Sheets)
identity/
  who-i-am.md               # Your bio, background, goals
  professional-background.md # Credentials and credibility
writing/
  skills/
    avoid-ai-writing/
      SKILL.md               # Audit and rewrite content to remove AI writing patterns
projects/
  README.md                  # How to build a project section
  example-musician/          # Example: a musician's promotion workflow
    README.md
    artist-context.md
    promotion-strategy.md
    skills/
      social-post/SKILL.md
      press-outreach/SKILL.md
references/
  gws-mcp-setup.md           # Google Workspace CLI setup guide
state/
  current.md                 # Active priorities and open threads
  weekly-priorities.md       # What matters most this week
commands/
  start.md                   # /start session command
```

## Setup

### 1. Clone and personalize

```bash
git clone https://github.com/conorbronsdon/claude-context-starter.git my-context
cd my-context
```

Fill in the `[FILL IN]` placeholders throughout — start with `identity/who-i-am.md`.

### 2. Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

### 3. Set this repo as your context source

Point Claude Code at this directory when starting sessions:

```bash
cd /path/to/my-context
claude
```

Claude will auto-load `CLAUDE.md` on every session start.

### 4. Set up Google Workspace MCP (optional but recommended)

See `references/gws-mcp-setup.md` for full instructions. Short version:

```bash
npm install -g @googleworkspace/cli
gws auth setup
```

The `.mcp.json` in this repo is already configured — Claude Code will pick it up automatically when you run it from this directory.

### 5. Add your own projects

See `projects/README.md`. The `example-musician/` project shows the pattern — copy, rename, and fill in for your own use case.

## How to use it

- Start every Claude Code session with `/start` — loads your state and pulls live calendar/email data
- Use `/clean-ai-writing` to audit any content for AI writing patterns
- Add slash commands to `CLAUDE.md` as you build out skills
- Tell Claude to update files when context changes — it will commit the changes

## Keeping it current

Claude Code will maintain this repo for you if you ask it to. Tell it:
- "Update `state/current.md` with what we worked on today"
- "Add this to the CHANGELOG"
- "Regenerate ROUTING.md to include the new project I just added"

The more you use it, the better calibrated it gets.
