---
name: recover
description: Scan for orphaned worktrees and stale branches after crashes or abandoned sessions. Offers safe cleanup options.
allowed-tools: Read, Glob, Grep, Bash
---

# /recover — Worktree & Branch Cleanup

Scan for orphaned worktrees, stale branches, and partial work left behind by crashed or abandoned Claude Code sessions. Read-only by default — reports findings and waits for approval before cleanup.

## When to Use

- After a system crash or forced session termination
- When parallel session warnings fire about stale processes
- When `/reconcile` finds commits on unknown branches
- Periodic hygiene (monthly or after heavy parallel work)

## Instructions

### 1. List all worktrees

```bash
git worktree list --porcelain
```

Identify:
- **Active worktrees**: Have a running Claude Code session
- **Orphaned worktrees**: Directory exists but no session is using it
- **Stale entries**: Git tracks a worktree but the directory is gone

### 2. Inspect orphaned worktrees

For each orphaned worktree:

```bash
# Check for uncommitted changes
git -C <worktree-path> status --short

# Check what branch it's on
git -C <worktree-path> branch --show-current

# Show last commit
git -C <worktree-path> log --oneline -3

# Check if branch has unmerged commits vs main
git log main..<branch-name> --oneline
```

Classify each as:
- **CLEAN**: No unmerged commits, no uncommitted changes — safe to remove
- **HAS COMMITS**: Unmerged commits exist — needs merge decision
- **HAS CHANGES**: Uncommitted work — needs save decision
- **BOTH**: Unmerged commits AND uncommitted changes — needs careful handling

### 3. List stale branches

```bash
# Local branches not merged to main
git branch --no-merged main

# Remote branches gone from origin
git remote prune origin --dry-run

# All branches with last commit date
git for-each-ref --sort=-committerdate --format='%(refname:short) %(committerdate:relative) %(subject)' refs/heads/
```

Classify each branch:
- **MERGED**: Already in main — safe to delete
- **STALE**: Last commit >7 days ago, not merged — flag for review
- **ACTIVE**: Recent commits, likely in-use — leave alone

### 4. Check for prunable git state

```bash
git worktree prune --dry-run
```

### 5. Report

```
RECOVER — [DATE]

WORKTREES:
- Active: [N] (list with paths)
- Orphaned: [N]
  - [path] — [CLEAN/HAS COMMITS/HAS CHANGES/BOTH] — [branch name] — [last commit summary]
- Stale entries: [N] (directory gone, git still tracking)

BRANCHES:
- Merged (safe to delete): [list]
- Stale (>7 days, not merged): [list with last commit date and summary]
- Active: [list]

PROPOSED ACTIONS:
1. [action] — [target] — [reason]
2. ...

OVERALL: [CLEAN — nothing to recover / N items need attention]
```

### 6. Cleanup (with approval only)

**Only proceed when explicitly approved.** For each approved action:

- **Remove CLEAN orphaned worktree**: `git worktree remove <path>`
- **Remove worktree with changes (after confirming discard)**: `git worktree remove --force <path>`
- **Merge unmerged commits first**: `git merge <branch> --no-ff -m "recover: merge orphaned work from <branch>"`
- **Cherry-pick specific commits**: `git cherry-pick <commit-hash>`
- **Delete merged branches**: `git branch -d <branch>`
- **Delete stale branches (after confirming)**: `git branch -D <branch>`
- **Prune stale worktree entries**: `git worktree prune`
- **Prune stale remote refs**: `git remote prune origin`

After cleanup, commit any merged work:
```
recover: merge [N] orphaned branches, prune [N] stale worktrees
```

## Design Principles

- **Read-only by default.** Report findings, wait for approval.
- **Preserve work.** Default to merge/cherry-pick over discard. Only remove CLEAN worktrees without asking.
- **Specific.** Show exact commit hashes, file lists, and branch names.
- **Fast.** Git commands only — no deep file reads. Should complete scan in under 15 seconds.
- **Complement `/reconcile`.** Reconcile checks content drift. Recover handles structural cleanup.
