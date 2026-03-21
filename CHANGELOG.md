# Changelog

## [Unreleased]

## [0.7.1] — Safety contract and /recover
### Added
- `docs/safety-contract.md` — centralized policy for actions requiring confirmation (approval patterns, advisory warnings, design principles)
- `commands/recover.md` — scan orphaned worktrees and stale branches after crashes, offer safe cleanup
- `CLAUDE.md` — added `/recover` to command table, added safety contract reference

---

## [0.7.0] — Infrastructure, hooks, state layer, and new commands
### Added
- `scripts/pre-commit-hook.sh` — pre-commit hook: validates skills, guards CLAUDE.md size, warns on large context files, blocks secrets
- `scripts/setup.sh` — first-run setup: installs hook, makes scripts executable, generates repo map, checks tools
- `scripts/generate-repo-map.sh` — auto-generates REPO_MAP.md from directory structure
- `REPO_MAP.md` — auto-generated file/directory map
- `.github/workflows/validate.yml` — CI: skill validation on push/PR, REPO_MAP freshness check
- `.github/PULL_REQUEST_TEMPLATE.md` — PR checklist for skills, commands, and repo hygiene
- `.claude/hooks/session-start.sh` — advisory SessionStart hook: surfaces stale state, inbox items, overdue TODOs
- `.claude/hooks/ssot-guard.sh` — advisory PreToolUse hook: warns when editing SSOT files
- `.claude/hooks/README.md` — hook documentation with settings.local.json example
- `state/decisions.md` — append-only decision log template
- `state/blockers.md` — active blockers tracker template
- `state/heartbeat-log.md` — /today morning briefing log template
- `inbox/` — drop zone for unstructured notes, triaged by /capture
- `content/log.md` — published content log template
- `commands/capture.md` — /capture: triage inbox items into correct locations
- `commands/context.md` — /context: find relevant context files by topic keyword
- `commands/reconcile.md` — /reconcile: drift detection after parallel sessions
- `commands/content-shipped.md` — /content-shipped: log published content
- `references/notion-mcp-setup.md` — Notion MCP server setup guide
### Changed
- `CLAUDE.md` — added new commands to table; added parallel session guidance; added Claude Code vs claude.ai routing note; added generate-repo-map.sh to repo maintenance
- `README.md` — updated file tree with all new files; added setup.sh to setup steps; expanded command table with new commands

## [0.6.0] — Session lifecycle, validation, and skill scaffolding
### Added
- `commands/end.md` — `/end` command: log session, update state files, close the session loop
- `commands/update.md` — `/update` command: mid-session checkpoint for quick state saves
- `commands/today.md` — `/today` command: morning heartbeat with staleness checks and calendar
- `TODO.md` — canonical task backlog template (separate from state/current.md top-of-mind view)
- `docs/agent-template.md` — reusable scaffold for building new skills: SKILL.md template, command file template, pre-ship checklist
- `scripts/validate-skills.sh` — validation script: checks frontmatter, CLAUDE.md line count, secrets, staleness
### Changed
- `CLAUDE.md` — added `/end`, `/update`, `/today` to command table; added Single Source of Truth rules; added line limit convention; pointed skill creation at `docs/agent-template.md`
- `ROUTING.md` — added session management section; added skill-building section with agent-template reference
- `README.md` — updated file tree; added Session Lifecycle and Validation sections; documented the full session loop
- `sessions/README.md` — added structured session log format and `/end` integration guidance

## [0.5.0] — Skill infrastructure and housekeeping
### Added
- `commands/clean-ai-writing.md` — command file for `/clean-ai-writing`; also serves as the minimal command file pattern example
### Changed
- `writing/skills/avoid-ai-writing/SKILL.md` — added `upstream` frontmatter field and visible note pointing to https://github.com/conorbronsdon/avoid-ai-writing
- `projects/README.md` — documented full skill frontmatter spec: `requires`, `allowed-tools`, `upstream` fields with table, minimal example, and full example
- `references/gws-mcp-setup.md` — replaced hardcoded date with placeholder
- `CLAUDE.md` — `/clean-ai-writing` routing now points explicitly to skill file path instead of describing the task
- `README.md` — file tree updated to include `sessions/`, `state/gws-references.md`, `commands/clean-ai-writing.md`

## [0.4.0] — Broken references, missing files, and clarity fixes
### Added
- `.gitignore` — excludes .DS_Store, editor files, secrets, logs
- `sessions/` directory with `.gitkeep` and `sessions/README.md` explaining the session log pattern
- `state/gws-references.md` — template for storing Google Sheet/Drive IDs used by `/start`
### Changed
- `SETUP-PROMPTS.md` — intro updated to cover both Claude Code and claude.ai; Prompt 2 retitled "Set up your first project" with a note that questions are musician-specific and Prompt 3 is generic; Tips de-musician-ified
- `commands/start.md` — sessions reference updated to handle empty directory gracefully; gws-references step updated to degrade gracefully if no IDs are configured yet
- `projects/example-musician/README.md` — slash commands section now explains the commands/ pattern and links to Prompt 3 for automated setup

## [0.3.0] — claude.ai sync docs and cross-interface positioning
### Added
- `docs/claude-projects-sync.md` — dedicated guide for keeping claude.ai projects in sync: what to upload, how skills work in claude.ai, staying current, multi-project patterns
### Changed
- `README.md` — opening reframed to lead with cross-interface value; Step 5 updated to point to sync doc; new "Skills work everywhere" section with avoid-ai-writing as the concrete example
- `docs/migration-guide.md` — Part 3 condensed; links to claude-projects-sync.md for ongoing workflow

## [0.2.0] — Setup prompts
### Added
- `SETUP-PROMPTS.md` — four interactive prompts: fill in identity, set up musician project, build any new project section, refresh weekly state

## [0.1.0] — Initial template
### Added
- `CLAUDE.md` — main context file with slash commands and thought-partner mode
- `ROUTING.md` — context routing table
- `identity/who-i-am.md` — personal bio template
- `identity/professional-background.md` — credentials template
- `writing/skills/avoid-ai-writing/SKILL.md` — AI writing pattern audit skill
- `projects/README.md` — guide for building project sections
- `projects/example-musician/` — example project: musician promotion workflow
- `references/gws-mcp-setup.md` — Google Workspace CLI setup guide
- `state/current.md` — session state template
- `state/weekly-priorities.md` — weekly priorities template
- `commands/start.md` — /start session command
- `.mcp.json` — Google Workspace MCP server config
