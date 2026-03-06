# Migration Guide

You have existing Claude projects with uploaded files, custom instructions, and conversation history. This guide walks through auditing them, deciding what to keep, moving it into this repo, and connecting the repo to claude.ai going forward.

---

## Overview

The process has three parts:

1. **Audit** — run a prompt in each existing project to inventory what's there
2. **Migrate** — move anything worth keeping into this repo
3. **Connect** — upload the key repo files to claude.ai so your new projects read from the same source

Plan for 15–30 minutes per project, though most go faster.

---

## Part 1: Audit your existing projects

Open each Claude project and run this prompt. It works for any project regardless of what's in it.

---

**Copy this prompt into each project:**

```
I'm consolidating my Claude context into a git-based personal context repo.
The repo contains version-controlled files for my identity, projects, writing,
and any custom skills — and it syncs to claude.ai projects going forward.

Before I archive or delete this project, help me take inventory.

1. List every document or file uploaded to this project's knowledge, with a
   one-sentence summary of what each contains.

2. Show me the full text of any custom instructions set for this project.

3. For each piece of content, flag whether it's:
   - MIGRATE: contains context, preferences, or instructions I should carry forward
   - SKIP: generic, outdated, or already captured elsewhere
   - UNCLEAR: you're not sure — flag it and let me decide

4. For anything flagged MIGRATE, output the raw content so I can evaluate it.

5. Note any content that appears stale — outdated job titles, old company names,
   superseded strategies, or anything likely out of date.

Be thorough. I want to make a confident decision about this project when we're done.
```

---

**What to do with the output:**

Read through what it surfaces. Most projects fall into one of three buckets:

- **Delete after a quick scan.** Old projects built around a specific job, company, or one-time task. The custom instructions are usually outdated and the uploaded files have no forward value. Confirm, then delete.

- **Extract a few things, then delete.** The project has one or two documents worth migrating — a strategy framework, a research doc, a set of preferences you'd forgotten. Pull those, add them to the repo, then delete the project.

- **Carefully migrate.** A recently active project with working context — episode guides, client notes, an evolving strategy. These take more work but are worth doing right.

---

## Part 2: Move content into this repo

Once you know what to keep, decide where each piece lives.

**Identity and background** → `identity/`
Use `who-i-am.md` for personal context, `professional-background.md` for credentials. If neither fits, create a new file in the same directory.

**Project-specific context** → `projects/your-project-name/`
Copy the pattern from `projects/example-musician/`. Each project gets its own directory with a README, context files, and a `skills/` subdirectory for recurring workflows. Use Prompt 3 in `SETUP-PROMPTS.md` to have Claude build the folder structure interactively.

**Skills** (recurring task instructions) → `projects/your-project/skills/skill-name/SKILL.md`
If the project had a detailed system prompt for a specific task — writing in a particular format, analyzing a particular type of content — that's a skill. Extract it, clean it up, and file it here. Register it as a slash command in `CLAUDE.md`.

**Career and financial context** → `career/` or a new top-level directory
Long-term strategies, role context, financial planning notes. Create the directory if it doesn't exist.

**State and current priorities** → `state/current.md` and `state/weekly-priorities.md`
Anything about what you're actively working on goes here, not in identity files.

---

**When you're not sure where something goes**, ask Claude Code:

```
I'm migrating context from an old Claude project. Here's the content:

[paste content]

Where in this repo does it belong? If it needs a new file, suggest the path and filename.
```

---

## Part 3: Connect the repo to claude.ai

Claude Code reads this repo directly from the filesystem. claude.ai projects read from uploaded files in project knowledge. The migration step here is simple: upload your core files to each project you want to keep using.

**At minimum, upload to each project:**
- `CLAUDE.md` — your identity and routing instructions
- `ROUTING.md` — the full context routing table
- Any project-specific context or skill files relevant to that project's focus

**How to upload:**
In claude.ai, open the project → Project knowledge → Add content → Upload files.

For ongoing sync — keeping projects current as you update the repo, using skills in claude.ai, running multiple focused projects from one source — see [claude-projects-sync.md](claude-projects-sync.md) for the full workflow.

---

## Checklist

- [ ] Ran the audit prompt in every existing project
- [ ] Decided MIGRATE / SKIP for each piece of content
- [ ] Moved all MIGRATE content into the appropriate place in this repo
- [ ] Registered any extracted skills as slash commands in `CLAUDE.md`
- [ ] Updated `identity/who-i-am.md` with anything that was missing
- [ ] Uploaded the core files (`CLAUDE.md`, `ROUTING.md`, relevant project files) to each claude.ai project
- [ ] Archived or deleted old projects you no longer need

---

## Common questions

**Do I need Claude Code, or can I just use claude.ai?**
You can use either. Claude Code can maintain the repo for you — updating files, committing changes, running slash commands. claude.ai can read from the uploaded files but can't write back to the repo. Most people use both: Claude Code for active work sessions and context maintenance, claude.ai for tasks in the browser.

**What if a project has a lot of conversation history worth keeping?**
Conversation history doesn't migrate cleanly. What you want is the *output* of those conversations — the decisions made, the documents produced, the strategies that emerged. Ask the project to summarize the key decisions and outputs from recent conversations, then save that summary as a reference file in the repo.

**How often should I update these files?**
Update them when something meaningfully changes — a new job, a new project, a strategy shift, a completed goal. Don't over-maintain. The `state/` files are worth touching most often; the `identity/` files should be stable for months at a time.

**What's the ROUTING.md file for?**
It's a lookup table for Claude: given a type of task, which files should it read? It reduces the chance of Claude answering a career question without reading your career context, or editing your writing without loading your voice guidelines. Update it whenever you add a new skill or project.
