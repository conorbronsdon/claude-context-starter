---
name: dream-apply
description: Walk a dream proposal artifact, review each item, apply accepted ones to memory and commit.
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion
---

# /dream-apply — review + apply a curator pass

Substrate background: `docs/dream-architecture.md`.

## Usage

```
/dream-apply {ISO-timestamp}
/dream-apply latest        # auto-resolves to most recent .dreams/ subdir
```

## Steps

### 1. Resolve the dream dir

```
PROJECT_KEY=$(pwd | sed 's|[:\\/]|-|g')
DREAMS_ROOT="$HOME/.claude/projects/$PROJECT_KEY/memory/.dreams"
```

If `$ARGUMENTS` is `latest` or empty: pick the most recent subdir by name (ISO timestamps sort lexically). Otherwise treat `$ARGUMENTS` as the ISO timestamp.

If the dir doesn't exist, list available dreams and stop.

### 2. Load the proposal artifact

Read `$DREAMS_ROOT/$TS/proposals.json` and `$DREAMS_ROOT/$TS/REPORT.md`. If either is missing, stop with an error.

### 3. Show the report header

Print the top of REPORT.md (header + counts). Don't dump the whole thing — the user already has it if they want the full text.

### 4. Walk each proposal

For each `proposals[i]`:

a. Print:
   ```
   ─── Proposal {id} ({i+1}/{N}) ───
   Action: {action}    Target: {target}    Confidence: {confidence}
   Reasoning: {reasoning}
   Evidence:
     - {evidence[0]}
     - {evidence[1]}

   Current:
     {current_excerpt}

   Proposed:
     {proposed_excerpt}
   ```

b. Ask via `AskUserQuestion`:
   - Question: "Apply this proposal?"
   - Options: `Accept` / `Reject` / `Edit then accept` / `Skip rest`
   - For `high` confidence: order options Accept-first.
   - For `medium`: order Reject-first (forces reading).
   - For `flag` (rot ambiguous): order Reject-first; treat Accept as opt-in only.

c. On `Accept`: apply the change.
   - For `modify` action: use Edit tool on `memory/{target}`, replacing `current_excerpt` with `proposed_excerpt`.
   - For `archive` action: append a row to `memory/ARCHIVE.md` (`| {today} | {target} | {one-line reason from proposal.reasoning} |`), then remove the corresponding line from `memory/MEMORY.md` index, then leave the file in place (don't delete the .md).
   - For `add` action (pattern curator, v0.2): create new memory file with proposed content, add an index line to `memory/MEMORY.md`.
   - For `flag` action: write nothing — flags are just surfacing.

d. On `Edit then accept`: open `proposed_excerpt` for inline edit (use `AskUserQuestion` with an "Other" textarea option), then apply the edited version.

e. On `Reject`: skip, log to `applied.json` as `rejected`.

f. On `Skip rest`: break the loop, log remaining as `deferred`.

### 5. Write `applied.json` to the dream dir

```json
{
  "applied_at": "{ISO}",
  "decisions": [
    {"id": "rot-001", "decision": "accepted"},
    {"id": "rot-002", "decision": "rejected"},
    {"id": "rot-003", "decision": "edited", "edited_excerpt": "..."}
  ]
}
```

### 6. Commit to memory git

```
cd "$HOME/.claude/projects/$PROJECT_KEY/memory"
git add -A
git commit -m "dream-apply($TS): N accepted / M rejected / K deferred"
```

If no proposals were accepted, still commit `applied.json` so the audit trail is complete.

### 7. Final summary

```
Dream apply complete: {TS}
Accepted: N    Rejected: M    Edited: K    Deferred: L
Memory git HEAD: {short-sha}    Files changed: {count}

Reverting this pass: cd <memory dir> && git revert HEAD
```

## Safety rules

- Never push memory git anywhere. Local-only. If a remote has been added, refuse to apply and ask the user to remove it.
- Never accept a proposal with empty `evidence`. Reject + warn that the curator violated the schema.
- If applying a `modify` and the `current_excerpt` doesn't match the file (because memory was edited between dream + apply), Edit tool will error. Surface the conflict, ask the user to resolve manually.
- Don't auto-apply anything. Every proposal goes through review.
