---
name: dream
description: Run a curator pass against the memory dir. Produces a proposal artifact for /dream-apply. Default curator: rot.
allowed-tools: Read, Bash, Write, Glob, Grep
---

# /dream — autonomous memory curator pass

Substrate background: `docs/dream-architecture.md`. Curator prompts: `scripts/dream/prompts/`.

## Usage

```
/dream             # default curator: rot
/dream rot         # explicit
/dream pattern     # NOT YET BUILT (v0.2)
/dream contradiction  # NOT YET BUILT (v0.3)
/dream untapped    # NOT YET BUILT (v0.4)
/dream audit       # NOT YET BUILT (v0.5)
```

## Steps

### 1. Resolve curator name

If `$ARGUMENTS` is empty or `rot`, proceed with rot. If anything else, check whether `scripts/dream/prompts/{name}.md` exists. If not, list available curators and stop.

### 2. Resolve the memory dir + generate ISO timestamp

```
PROJECT_KEY=$(pwd | sed 's|[:\\/]|-|g')
MEMORY_DIR="$HOME/.claude/projects/$PROJECT_KEY/memory"
TS=$(date -u +%Y-%m-%dT%H-%M-%SZ)
DREAM_DIR="$MEMORY_DIR/.dreams/$TS"
mkdir -p "$DREAM_DIR"
```

If `$MEMORY_DIR/.git` doesn't exist, stop and tell the user to run the first-time setup from `scripts/dream/README.md`.

### 3. Load the curator prompt

Read `scripts/dream/prompts/{curator}.md` in full. This is your role + output schema for the rest of this command.

### 4. Gather inputs (read-only)

Per the curator's required inputs (rot needs all of these):

- `ls $MEMORY_DIR/*.md` and read each `project_*.md` / `reference_*.md` (skip `env_`, `feedback_`, `user_` unless the curator asks)
- Read `state/decisions.md`, `state/blockers.md`, `state/current.md`
- `find sessions/ -name "*.md" -mtime -14` and read each
- `git log --since="14 days ago" --oneline` for the current repo

### 5. Write `inputs.json` to the dream dir

Record what was fed in (file paths + line counts), so the run is reproducible.

```json
{
  "curator": "rot",
  "ran_at": "{ISO}",
  "memory_files_read": [...],
  "state_files_read": [...],
  "session_files_read": [...],
  "git_log_window_days": 14,
  "git_log_commit_count": N
}
```

### 6. Run the curator

Following the role + question + classification logic in the loaded prompt, walk every input target and produce findings. **Be conservative — empty-evidence proposals get rejected at apply time.**

### 7. Write `proposals.json` to the dream dir

Schema is defined in the curator prompt. Each proposal must have: `id`, `action`, `target`, `reasoning`, `evidence` (array, never empty), `current_excerpt`, `proposed_excerpt`, `confidence`.

### 8. Write `REPORT.md` to the dream dir

Human-readable summary per the curator prompt's format. Top: dream-pass header + counts. Then findings grouped by confidence. Then skipped items. Footer: `Run /dream-apply {ISO} to review and apply.`

### 9. Commit the artifact to memory git

```
cd "$MEMORY_DIR"
git add ".dreams/$TS/"
git commit -m "dream($TS): {curator} — N proposals (H high / M med / L flag)"
```

### 10. Surface the result

Print:

```
Dream pass complete: {curator}
Artifact: memory/.dreams/{ISO}/REPORT.md
Proposals: N (H high, M medium, L flag)
Top finding: {one-line summary of the highest-confidence proposal}

Review and apply: /dream-apply {ISO}
```

## Scope guards

- Curator MUST NOT modify any input file. Read-only on `memory/`, `state/`, `sessions/`.
- Curator MUST NOT push the memory git repo to any remote. Local-only by design.
- If `$ARGUMENTS` names a curator that hasn't been built yet, refuse politely and list what is available.
