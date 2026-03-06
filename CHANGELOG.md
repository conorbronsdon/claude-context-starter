# Changelog

## [Unreleased]

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
