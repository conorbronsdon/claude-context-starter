# Dream — autonomous memory curator

**Status:** v0.1 substrate. First curator prompt: rot detection.

## Why this exists

Memory accumulates faster than humans review it. The only forcing functions are `/end` (hand-curated at session close, biased toward what's fresh in context) and `/today` (morning heartbeat, biased toward today's priorities). Neither catches:

1. **Rot** — project memories stale within days ("X submitted, awaiting approval" → false a week later)
2. **Cross-session patterns** — same friction hit 3+ times across sessions but only captured as a memory once
3. **Contradictions** — two memory rules giving conflicting guidance, both still indexed
4. **Untapped patterns** — recurring session-log themes that never got promoted to memory
5. **Adherence drift** — sessions ignoring rules they should have followed

These are LLM-shaped tasks: pattern detection across 7-30 days of episodic memory, compression into semantic rules, contradiction detection.

The bet: compounding pattern-capture over months beats waiting for the perfect memory product. Curator file shapes (markdown + JSON proposals) stay portable even if the runner gets thrown away.

## Architecture

### Three layers

```
┌─────────────────────────────────────────────────────────────────┐
│ LAYER 1: Inputs (read-only)                                     │
│   sessions/*.md  state/*.md  memory/*.md  git log (14d)         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ LAYER 2: Curator pass (prompted)                                │
│   /dream {curator-name}                                         │
│   Curator prompts live in scripts/dream/prompts/                │
│   {rot, pattern, contradiction, untapped, audit}.md             │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ LAYER 3: Proposal artifact (write to memory git)                │
│   memory/.dreams/{ISO}/                                         │
│     REPORT.md       — human-readable summary                    │
│     proposals.json  — machine-readable per-item diff            │
│     inputs.json     — what was fed in (reproducibility)         │
│   Committed to memory git on creation.                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ APPLY: separate command, gated on human review                  │
│   /dream-apply {ISO-timestamp}                                  │
│   Walks proposals.json, asks accept/reject/edit per item,       │
│   applies accepted to memory files, commits in memory git.      │
└─────────────────────────────────────────────────────────────────┘
```

### Why slash commands, not standalone Python

1. **No separate API key.** The curator runs inside the existing Claude Code session — same model, same auth.
2. **Easier prompt iteration.** Curator prompts are markdown files; tweak one, run again, no redeploy.
3. **Structured-tool access.** `AskUserQuestion` for the apply step gives a real review UI rather than terminal Y/N.

Tradeoff: can't run truly unattended. To schedule, use `/loop` or wire a remote agent via `/schedule` that fires `claude --headless /dream rot`.

### Why git on the memory dir

Three load-bearing benefits once a curator runs autonomously:

1. **Diff before/after.** "What changed in this dream pass" is the most-asked question after every run.
2. **Revert path.** A bad accept-all on `/dream-apply` is one `git revert` away.
3. **Migration insurance.** `cp -r memory/ <new machine>` + `git log` keeps the full history.

**Local-only repo. No remote.** Memory often contains personal or confidential context. If you need backup, snapshot to a private location separately.

### Storage layout

```
~/.claude/projects/<encoded-cwd>/memory/
├── .git/                   ← local-only repo
├── MEMORY.md               ← index (cap 100 lines)
├── ARCHIVE.md              ← pruned/superseded entries
├── {topic}.md              ← detail files
└── .dreams/                ← curator artifacts
    └── {ISO-timestamp}/
        ├── REPORT.md       ← human review surface
        ├── proposals.json  ← machine apply surface
        └── inputs.json     ← reproducibility
```

### Proposal schema (v0.1)

Each proposal is one of four actions: `modify`, `archive`, `add`, `flag`.

```json
{
  "id": "rot-001",
  "action": "modify",
  "target": "project_acme_migration.md",
  "reasoning": "Memory says 'Acme migration awaiting approval.' state/blockers.md (2026-03-04 update) shows it shipped. Update memory to reflect shipped status.",
  "evidence": [
    "state/blockers.md L24: 'Acme migration shipped 2026-03-04'",
    "sessions/2026-03-05.md: '...Acme migration deployed clean'"
  ],
  "current": "<excerpt of memory file>",
  "proposed": "<rewritten excerpt>",
  "confidence": "high"
}
```

Apply step honors `confidence`: `high` defaults to accept, `medium` shows full diff, `low` requires explicit edit.

## Curator catalog (build order)

### v0.1: rot (ships with starter)

**Question:** "For each project-type memory entry, does it still match the current state of the world?"

**Inputs:** `memory/project_*.md` + `state/{decisions,blockers,current}.md` + `git log --since=14.days.ago`.

**Output actions:** `modify`, `archive`, `flag`.

**Why first:** Easiest objective spec. Lowest false-positive cost ("no, this is still true" is cheap to dismiss). Runs against existing data, proves substrate value on day 1.

### v0.2: pattern (next)

**Question:** "What recurring frictions in the last 14 days of sessions don't have a memory entry yet?"

**Inputs:** `sessions/*.md` (last 14d) + `memory/*.md` (to dedupe).

**Output actions:** `add` (new memory candidate). Required-evidence floor: must appear in 3+ sessions to propose.

### v0.3: contradiction (later)

**Question:** "Does memory contain rules that give conflicting guidance for the same situation?"

**Output actions:** `flag` (always — never auto-resolve a contradiction; surface to the user).

### v0.4: untapped (later)

**Question:** "What recurring themes in session logs have never been raised into memory or a skill?"

**Output actions:** `flag`.

### v0.5: audit (later, possibly never)

**Question:** "Did sessions in the last 7 days follow the rules in MEMORY.md?"

**Risk:** Memory rules aren't structured enough to mechanically check adherence. May produce noise. Hold until v0.4 ships.

## What this deliberately doesn't do (v0.1)

- **No skill generation.** Skills stay manual via `/skill-creator` (or your own equivalent).
- **No autonomous apply.** Review gate stays. Maybe never removed for high-stakes scopes.
- **No vector store / SQLite / FTS.** Plain markdown + JSON. Smallest substrate that works.
- **No scheduled trigger.** Manual `/dream rot` for v0.1. Schedule via `/loop` once the prompt stabilizes for your workflow.

## Risks + mitigations

| Risk | Mitigation |
|---|---|
| Curator hallucinates rot that's actually current | Required `evidence` array — every claim cites a state-file line or commit. Apply rejects empty-evidence proposals. |
| Apply step accept-all destroys good memories | Git on memory dir → revert is one command. Apply shows full diff before each accept. |
| Memory + state files drift apart over time | Curator reads both each pass; rot detector specifically cross-references them. |
| Confidential memory leaks via accidental `git push` | No remote configured. Pre-commit hook on memory git: refuse if any remote is added. (TODO.) |

## Open questions

- Should `state/decisions.md` ever be a curator write target? Currently read-only.
- Should the curator propose `CLAUDE.md` changes when a feedback rule validates 3+ times? Promotion changes Claude's default behavior — high-leverage and high-risk.
- Multi-repo curators? Same substrate could run against any project's `state/` + `memory/`.

## Files

| Path | Role |
|---|---|
| `docs/dream-architecture.md` | This file. |
| `docs/auto-memory.md` | Memory spec the curator operates on. |
| `scripts/dream/README.md` | How to use, how to add curators. |
| `scripts/dream/prompts/rot.md` | Rot-detector prompt body. |
| `commands/dream.md` | `/dream {curator}` slash command. Default: `rot`. |
| `commands/dream-apply.md` | `/dream-apply {timestamp}` slash command. |
| `~/.claude/projects/<encoded-cwd>/memory/.git/` | Local-only repo for memory dir. Run `git init` there on first use. |
| `~/.claude/projects/<encoded-cwd>/memory/.dreams/` | Per-pass artifacts. Tracked. |
