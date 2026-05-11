# /dream — autonomous memory curator

Substrate for curator passes against `~/.claude/projects/<encoded-cwd>/memory/`.

**Full architectural rationale: `docs/dream-architecture.md`.**

## Usage

```
/dream [curator]              # default: rot. produces a proposal artifact, no apply.
/dream-apply {ISO-timestamp}  # walks the proposal, accept/reject/edit per item.
```

Curator catalog (build order):
- `rot` (v0.1, ships with starter) — flag project memories that no longer match state files / recent commits
- `pattern` (v0.2, planned) — propose new memories from recurring session-log frictions
- `contradiction` (v0.3, planned) — flag memory rules giving conflicting guidance
- `untapped` (v0.4, planned) — surface session-log themes never raised to memory
- `audit` (v0.5, maybe) — flag sessions that ignored MEMORY.md rules

## First-time setup

The memory dir is created automatically by Claude Code, but the git repo on it is not. Initialize it once:

```bash
PROJECT_KEY=$(pwd | sed 's|[:\\/]|-|g')
MEMORY_DIR="$HOME/.claude/projects/$PROJECT_KEY/memory"
mkdir -p "$MEMORY_DIR"
cd "$MEMORY_DIR"
git init
git add -A
git commit -m "initial memory snapshot"
```

No remote. The memory dir often contains personal or confidential context.

## Where things live

- **Curator prompts:** `prompts/{name}.md` here
- **Slash commands:** `commands/dream.md` + `commands/dream-apply.md` in the repo root
- **Proposal artifacts:** `~/.claude/projects/<encoded-cwd>/memory/.dreams/{ISO}/`
- **Memory git repo:** `~/.claude/projects/<encoded-cwd>/memory/.git/` (local-only, no remote)

## Adding a new curator

1. Write `prompts/{name}.md` with the curator's role + question + output schema (use `prompts/rot.md` as the template).
2. Add the curator name to the `/dream` slash command's accepted list.
3. Run `/dream {name}`, review the artifact, iterate the prompt.
4. Update `docs/dream-architecture.md` to mark the curator shipped.

## Why slash commands, not Python

Curator runs inside the existing Claude Code session — no separate API key, easier prompt iteration, structured-tool access for the apply step. Tradeoff: can't run truly unattended without `claude --headless`. Schedule via `/loop` once a prompt stabilizes for your workflow.
