#!/usr/bin/env bash
# setup.sh — First-run setup after cloning.
# Run once: bash scripts/setup.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "$REPO_ROOT"

echo "Setting up your context repo..."
echo ""

# ── 1. Install pre-commit hook ──────────────────────────────────────────────

if [ ! -f ".git/hooks/pre-commit" ]; then
  cp scripts/pre-commit-hook.sh .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit
  echo "  Installed pre-commit hook"
else
  echo "  Pre-commit hook already exists"
fi

# ── 2. Make scripts executable ──────────────────────────────────────────────

chmod +x scripts/*.sh 2>/dev/null || true
echo "  Scripts made executable"

# ── 3. Generate REPO_MAP.md (if script exists) ──────────────────────────────

if [ -f "scripts/generate-repo-map.sh" ]; then
  bash scripts/generate-repo-map.sh 2>/dev/null
  echo "  REPO_MAP.md generated"
fi

# ── 4. Check for tools ─────────────────────────────────────────────────────

echo ""
echo "Checking tools..."

if command -v claude &>/dev/null; then
  echo "  Found: claude"
else
  echo "  Missing: claude — install with: npm install -g @anthropic-ai/claude-code"
fi

if command -v git &>/dev/null; then
  echo "  Found: git"
else
  echo "  Missing: git"
fi

if command -v gws &>/dev/null; then
  echo "  Found: gws (Google Workspace CLI)"
else
  echo "  Optional: gws not found — see references/gws-mcp-setup.md for Google Workspace integration"
fi

# ── 5. Done ─────────────────────────────────────────────────────────────────

echo ""
echo "Setup complete. Next steps:"
echo ""
echo "  1. Run: cd $REPO_ROOT && claude"
echo "  2. Type: /start"
echo "  3. Follow SETUP-PROMPTS.md to build your context files"
echo ""
echo "Optional: add an alias to your shell profile:"
echo "  alias cc='cd $REPO_ROOT && claude'"
