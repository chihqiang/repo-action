#!/usr/bin/env bash
set -euo pipefail

# ======================
# Print mpgrm version
# ======================
echo "🛠️ mpgrm version:"
mpgrm --version || echo "⚠️ mpgrm not installed or not found in PATH"

# ======================
# Export environment variables from GitHub Action inputs
# ======================
export REPO="${INPUT_REPO:-https://github.com/${GITHUB_REPOSITORY}.git}"
export USERNAME="${INPUT_USERNAME:-$GITHUB_ACTOR}"

export PASSWORD="${INPUT_PASSWORD:-}"
export TOKEN="${INPUT_TOKEN:-}"

export TARGET_REPO="${INPUT_TARGET_REPO:-}"
export TARGET_USERNAME="${INPUT_TARGET_USERNAME:-}"
export TARGET_PASSWORD="${INPUT_TARGET_PASSWORD:-}"
export TARGET_TOKEN="${INPUT_TARGET_TOKEN:-}"

export TAGS="${INPUT_TAGS:-}"
export FILES="${INPUT_FILES:-}"

# ======================
# Debug: print environment variables (optional)
# ======================
echo "========= Environment Variables ========="
echo "[SOURCE REPO]"
echo "  REPO            : $REPO"
echo "  USERNAME        : $USERNAME"
echo
echo "[TARGET REPO]"
echo "  TARGET_REPO     : $TARGET_REPO"
echo "  TARGET_USERNAME : $TARGET_USERNAME"
echo
echo "[EXTRAS]"
echo "  TAGS            : $TAGS"
echo "  FILES           : $FILES"
echo "=========================================="

# ======================
# Upload: REPO + (TOKEN or PASSWORD) + TAGS + FILES
# ======================
if [[ -n "$REPO" && -n "$TAGS" && -n "$FILES" && ( -n "$TOKEN" || -n "$PASSWORD" ) ]]; then
  echo "✅ Starting upload..."
  mpgrm releases upload --repo "$REPO" --tags "$TAGS" --files "$FILES" 
fi

# ======================
# Sync to TARGET_REPO: TARGET_REPO + TARGET_USERNAME + (TARGET_PASSWORD or TARGET_TOKEN)
# ======================
if [[ -n "$TARGET_REPO" && -n "$TARGET_USERNAME" && ( -n "$TARGET_PASSWORD" || -n "$TARGET_TOKEN" ) ]]; then
  echo "✅ Starting sync to target repository..."
  mpgrm push --repo "$REPO" --target-repo "$TARGET_REPO" --username "$TARGET_USERNAME" 
  # Sync tags if TAGS and (TOKEN or TARGET_TOKEN) are present
  if [[ -n "$TAGS" && ( -n "$TOKEN" || -n "$TARGET_TOKEN" ) ]]; then
    echo "🔖 Syncing tags: $TAGS"
    mpgrm releases sync --repo "$REPO" --target-repo "$TARGET_REPO" --tags "$TAGS"
  fi
fi
