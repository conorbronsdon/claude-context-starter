#!/bin/bash
# SessionStart hook: surface non-default-branch state on guarded repos so a
# silent branch-switch by a parallel session (HEAD changed underneath us) is
# noticed BEFORE any edits land in the wrong place.
#
# Stays quiet when:
#   - on the default branch (main/master)
#   - cwd is not in a guarded repo (see .claude/hooks/guarded-repos.txt)
#   - branch is non-default but tree is clean AND last commit < 2 min ago
#     (= almost certainly a worktree this session just created)

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
# Worktrees report their own dirname; resolve canonical repo via git-common-dir.
GIT_COMMON_DIR=$(git rev-parse --git-common-dir 2>/dev/null)
case "$GIT_COMMON_DIR" in
  /*|[A-Za-z]:*) CANONICAL_ROOT=$(dirname "$GIT_COMMON_DIR") ;;
  *) CANONICAL_ROOT=$(cd "$(dirname "$GIT_COMMON_DIR")" && pwd) ;;
esac
REPO_NAME=$(basename "$CANONICAL_ROOT")

# Is this repo guarded?
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
GUARD_LIST="$SCRIPT_DIR/guarded-repos.txt"
[ ! -f "$GUARD_LIST" ] && exit 0

if ! grep -v '^[[:space:]]*#' "$GUARD_LIST" | grep -v '^[[:space:]]*$' | grep -Fxq "$REPO_NAME"; then
  exit 0
fi

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
[ -z "$BRANCH" ] && exit 0

# Resolve the repo's default branch via origin/HEAD; fall back to "main".
DEFAULT=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
[ -z "$DEFAULT" ] && DEFAULT="main"
[ "$BRANCH" = "$DEFAULT" ] && exit 0

UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l)
LAST_COMMIT=$(git log -1 --format='%cr by %an' 2>/dev/null)
AHEAD_BEHIND=$(git rev-list --left-right --count "$DEFAULT...HEAD" 2>/dev/null)
BEHIND=${AHEAD_BEHIND%%[[:space:]]*}
AHEAD=${AHEAD_BEHIND##*[[:space:]]}

# Quiet path: clean tree + very recent commit = freshly created worktree.
LAST_TS=$(git log -1 --format='%ct' 2>/dev/null)
NOW=$(date +%s)
if [ -n "$LAST_TS" ] && [ "$UNCOMMITTED" -eq 0 ]; then
  AGE=$((NOW - LAST_TS))
  [ "$AGE" -lt 120 ] && exit 0
fi

# Detect if HEAD is in a worktree vs primary checkout — useful for the message.
GIT_DIR=$(git rev-parse --git-dir 2>/dev/null)
case "$GIT_DIR" in
  *worktrees*) WHERE="worktree" ;;
  *) WHERE="primary checkout" ;;
esac

echo "=== BRANCH HYGIENE ($REPO_NAME, $WHERE) ==="
echo ""
echo "  HEAD:        $BRANCH (not $DEFAULT)"
echo "  Last commit: $LAST_COMMIT"
echo "  Uncommitted: $UNCOMMITTED file(s)"
echo "  vs $DEFAULT:  ahead $AHEAD, behind $BEHIND"
echo ""
echo "If this is unexpected (e.g. parallel session switched HEAD), reset before editing:"
echo "    git -C \"$REPO_ROOT\" checkout $DEFAULT"
echo "  or open a fresh worktree:"
echo "    git -C \"$REPO_ROOT\" worktree add ../${REPO_NAME}-<task> -b claude/<task>"
echo ""
echo "=== END BRANCH HYGIENE ==="
