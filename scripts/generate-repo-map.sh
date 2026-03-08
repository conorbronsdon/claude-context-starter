#!/usr/bin/env bash
# generate-repo-map.sh — Generates REPO_MAP.md, a scannable index of this repo.
# Run from repo root: bash scripts/generate-repo-map.sh
#
# Writes:          REPO_MAP.md
# Prints to stdout: generation status + diff summary since last generation

set -euo pipefail

# ─── Setup ────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "$REPO_ROOT"

OUTPUT="REPO_MAP.md"

GEN_DATE=$(date '+%Y-%m-%d')
COMMIT_HASH=$(git log --format='%h' -1 2>/dev/null || echo "untracked")
COMMIT_DATE=$(git log --format='%ad' --date=short -1 2>/dev/null || echo "")

# ─── Helpers ──────────────────────────────────────────────────────────────────

# Last git-tracked modification date; falls back to filesystem date for untracked files
file_last_modified() {
  local f="$1"
  local d
  d=$(git log --pretty=format:'%ad' --date=short -1 -- "$f" 2>/dev/null)
  if [ -z "$d" ]; then
    # macOS
    d=$(stat -f '%Sm' -t '%Y-%m-%d' "$f" 2>/dev/null) || \
    # Linux
    d=$(stat -c '%y' "$f" 2>/dev/null | cut -d' ' -f1) || \
    d="unknown"
  fi
  printf '%s' "$d"
}

# First # heading in a markdown file; falls back to filename without extension
file_description() {
  local f="$1"
  local h
  h=$(grep -m1 '^# ' "$f" 2>/dev/null | sed 's/^# //' | sed 's/[[:space:]]*$//')
  if [ -z "$h" ]; then
    h=$(basename "$f" .md)
  fi
  printf '%s' "$h"
}

# Extract a single-line frontmatter field value (between first --- delimiters)
parse_frontmatter_field() {
  local file="$1"
  local field="$2"
  awk -v field="$field" '
    BEGIN { in_fm=0; count=0 }
    /^---$/ {
      count++
      if (count == 1) { in_fm=1; next }
      if (count == 2) { exit }
    }
    in_fm && $0 ~ ("^" field ":") {
      val = substr($0, length(field) + 2)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", val)
      print val
      exit
    }
  ' "$file"
}

# Truncate a string to max chars with trailing ellipsis
truncate_str() {
  local s="$1"
  local max="${2:-120}"
  if [ "${#s}" -gt "$max" ]; then
    printf '%s\xe2\x80\xa6' "${s:0:$max}"
  else
    printf '%s' "$s"
  fi
}

# ─── Generate REPO_MAP.md ─────────────────────────────────────────────────────

{
  printf '# Repo Map\n\n'
  printf 'Generated: %s | Commit: %s (%s)\n\n' "$GEN_DATE" "$COMMIT_HASH" "$COMMIT_DATE"
  printf -- '---\n\n'

  # ── Skills Index ─────────────────────────────────────────────────────────────

  printf '## Skills Index\n\n'
  printf '| Skill | Description |\n'
  printf '|-------|-------------|\n'

  while IFS= read -r skill_file; do
    name=$(parse_frontmatter_field "$skill_file" "name")
    raw_desc=$(parse_frontmatter_field "$skill_file" "description")
    desc=$(truncate_str "$raw_desc" 120)
    printf '| `%s` | %s |\n' "$name" "$desc"
  done < <(find . -name 'SKILL.md' -not -path './.git/*' -not -path './antigravity-awesome-skills/*' -not -path './claude-skills-collection/*' | sort)

  printf '\n'

  # ── File Index ───────────────────────────────────────────────────────────────

  printf '## File Index\n\n'

  # Root-level .md files (excluding REPO_MAP.md itself to avoid circularity)
  root_files=()
  while IFS= read -r -d '' f; do
    root_files+=("$f")
  done < <(find . -maxdepth 1 -name '*.md' -not -name 'REPO_MAP.md' -print0 | sort -z)

  if [ "${#root_files[@]}" -gt 0 ]; then
    printf '### Root\n\n'
    printf '| File | Lines | Last Modified | Description |\n'
    printf '|------|-------|---------------|-------------|\n'
    for f in "${root_files[@]}"; do
      fname=$(basename "$f")
      lines=$(wc -l < "$f" | tr -d ' ')
      mod=$(file_last_modified "$f")
      desc=$(file_description "$f")
      printf '| `%s` | %s | %s | %s |\n' "$fname" "$lines" "$mod" "$desc"
    done
    printf '\n'
  fi

  # Per top-level directory (alphabetical, skipping .git and node_modules)
  while IFS= read -r dir; do
    [ -z "$dir" ] && continue
    dname=$(basename "$dir")

    # Collect .md files recursively (skip .gitkeep)
    dir_files=()
    while IFS= read -r -d '' f; do
      dir_files+=("$f")
    done < <(find "$dir" -name '*.md' -not -name '.gitkeep' -print0 | sort -z)

    [ "${#dir_files[@]}" -eq 0 ] && continue

    printf '### %s\n\n' "$dname"
    printf '| File | Lines | Last Modified | Description |\n'
    printf '|------|-------|---------------|-------------|\n'

    for f in "${dir_files[@]}"; do
      rel="${f#./}"
      lines=$(wc -l < "$f" | tr -d ' ')
      mod=$(file_last_modified "$f")
      desc=$(file_description "$f")
      printf '| `%s` | %s | %s | %s |\n' "$rel" "$lines" "$mod" "$desc"
    done

    printf '\n'
  done < <(find . -maxdepth 1 -mindepth 1 -type d \
    -not -name '.git' \
    -not -name 'node_modules' \
    -not -name 'antigravity-awesome-skills' \
    -not -name 'claude-skills-collection' \
    | sort)

  # ── Directory Tree ────────────────────────────────────────────────────────────

  printf '## Directory Tree\n\n'
  printf '```\n'
  printf '.\n'

  find . \
    -not -path './.git' \
    -not -path './.git/*' \
    -not -path './antigravity-awesome-skills/*' \
    -not -path './claude-skills-collection/*' \
    -not -name '.gitkeep' \
    -mindepth 1 \
    | sort \
    | awk -F'/' '{
        depth = NF - 2
        indent = ""
        for (i = 0; i < depth; i++) indent = indent "  "
        print indent "├── " $NF
      }'

  printf '```\n'

} > "$OUTPUT"

printf '✓ REPO_MAP.md written.\n'

# ─── Diff Summary (stdout only, not written to REPO_MAP.md) ───────────────────

LAST_MAP_COMMIT=$(git log --format='%H' -1 -- REPO_MAP.md 2>/dev/null || true)

if [ -z "$LAST_MAP_COMMIT" ]; then
  printf 'Initial generation — no previous baseline.\n'
else
  DIFF=$(git diff --name-status "${LAST_MAP_COMMIT}" HEAD -- '*.md' 2>/dev/null || true)
  ADDED=0; REMOVED=0; CHANGED=0
  while IFS= read -r line; do
    case "$line" in
      A*) ADDED=$((ADDED + 1)) ;;
      D*) REMOVED=$((REMOVED + 1)) ;;
      M*) CHANGED=$((CHANGED + 1)) ;;
    esac
  done <<< "$DIFF"
  printf '%s files added, %s files removed, %s files changed since last generation.\n' \
    "$ADDED" "$REMOVED" "$CHANGED"
fi
