---
name: context
description: Find relevant context files by topic. Use when you need to load files for a topic without a slash command, or when a task spans multiple domains.
allowed-tools: Read, Glob, Grep, Bash
---

# /context — Find Relevant Files by Topic

## Instructions

The user will provide a topic keyword or phrase. Find and load relevant context files.

### 1. Search strategy (run in parallel)

- **Filename match:** `Glob` for files containing the topic keyword in their name
- **Header match:** `Grep` for `# ` headings containing the topic in `.md` files
- **Content match:** `Grep` for the topic keyword across all `.md` files

### 2. Rank and filter

- Prioritize files in this order: skills > identity/career > state > sessions
- Exclude `sessions/` files unless the topic is very recent (last 3 days)
- Exclude `REPO_MAP.md`, `CHANGELOG.md`, and `node_modules/`

### 3. Load and summarize

- Read the top 3-5 most relevant files
- Give a 1-line summary of what each file contains relative to the topic
- Ask the user if they want to load additional files or dive deeper into any result

### Output format

```
Found 4 files related to "[topic]":

1. **skills/data-analysis/SKILL.md** — Skill for CSV/JSON analysis with visualization
2. **career/professional-background.md** — Career timeline mentioning [topic]
3. **state/current.md** — Active priority related to [topic]

Loaded files 1-3. Want me to go deeper on any of these?
```
