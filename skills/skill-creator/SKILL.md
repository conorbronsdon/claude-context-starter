---
name: skill-creator
description: Generate a new skill file and command routing file for this repo from a plain-language description of what the skill should do.
---

# skill-creator — Build New Skills Fast

Takes a plain-language description of a task and generates a ready-to-ship skill: the SKILL.md, the command routing file, and the CLAUDE.md additions needed to wire it in.

## When to Use

- "I want a skill that does X"
- "Build me a slash command for Y"
- "Add a skill for [recurring task I do]"

## Before You Start

Read:

- `docs/agent-template.md` — canonical file format and pre-ship checklist
- `CLAUDE.md` — current routing, so the new skill doesn't duplicate an existing one
- The most relevant existing skill in `writing/skills/` or `projects/*/skills/` — for style reference

## Instructions

### 1. Clarify the skill

Ask (or infer from context):

- **Name**: what should the slash command be called? (lowercase, hyphenated)
- **Trigger**: when should this skill activate? What does the user say or ask?
- **Input**: what does the skill need to work? (a link, a transcript, a filename, etc.)
- **Output**: what does it produce? (a draft, a log entry, a summary, a file?)
- **Tools needed**: Read, Write, Edit, Bash, Glob, WebFetch?

### 2. Draft the SKILL.md

Follow the template in `docs/agent-template.md` exactly. Include:

- YAML frontmatter with `name` and `description` (60+ chars, specific enough that Claude can decide whether the skill is relevant from the description alone)
- Clear "When to Use" section
- Step-by-step instructions
- Output format spec, if the skill produces something

Place it at one of:

- `writing/skills/<name>/SKILL.md` — writing/content skills
- `projects/<project>/skills/<name>/SKILL.md` — project-scoped skills
- `skills/<name>/SKILL.md` — general/meta skills (like this one)

### 3. Draft the command routing file

Short file in `commands/<name>.md` following the template in `docs/agent-template.md`. Frontmatter: `name`, `description`, `allowed-tools`. Body: one or two lines that load the SKILL.md.

### 4. Draft the CLAUDE.md additions

Two additions:

1. A row in the slash command table: `| /<name> | <brief description> |`
2. A routing rule in the appropriate section of "When to Load Additional Context" (if applicable)

### 5. Pre-Ship Checklist

Before presenting, verify the new skill satisfies all of these:

- [ ] Frontmatter `description` is specific (60+ chars) — vague descriptions degrade routing
- [ ] MCP calls (if any) have explicit limits — see `docs/mcp-efficiency.md`
- [ ] Confirmation gate on any action that changes external state — see `docs/safety-contract.md`
- [ ] Writing skills load `writing/skills/avoid-ai-writing/SKILL.md` when producing external content
- [ ] Memory writes follow `docs/auto-memory.md` (typed entries, MEMORY.md cap)
- [ ] Command stub created in `commands/`
- [ ] CLAUDE.md slash command table updated
- [ ] CHANGELOG.md entry added under `[Unreleased]`
- [ ] Runs cleanly via `bash scripts/validate-skills.sh`

### 6. Present for review

Show all three artifacts in a single response. Ask: "Want me to commit these, or make any changes first?"

### 7. On approval: commit and update CHANGELOG

Create the files, run `bash scripts/validate-skills.sh`, then update CHANGELOG.md with a new entry listing all added files.

## Output Format

Present each file in a labeled fenced code block:

````
**skills/<name>/SKILL.md**
```markdown
[content]
```

**commands/<name>.md**
```markdown
[content]
```

**CLAUDE.md additions**
```markdown
[the two snippets to add]
```
````
