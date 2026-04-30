#!/usr/bin/env bash
set -euo pipefail

# Usage: ./github_summary.sh [YYYY-MM-DD]
# If no date is given, defaults to today.

if [[ $# -gt 0 ]]; then
  TARGET_DATE="$1"
  # Validate format
  if ! date -d "$TARGET_DATE" +%Y-%m-%d &>/dev/null; then
    echo "Error: invalid date '$TARGET_DATE'. Expected format: YYYY-MM-DD" >&2
    exit 1
  fi
else
  TARGET_DATE=$(date +%Y-%m-%d)
fi

OUTPUT_DIR="/mnt/c/Users/rcoe6/OneDrive/Documents/Claude/Projects/XPQuest/Daily Logs"
OUTPUT_FILE="${OUTPUT_DIR}/github_summary-${TARGET_DATE}.md"
SEARCH_ROOT="/home/rcoe/xpquest"

# Build the --after / --before window for the target date
AFTER="${TARGET_DATE} 00:00:00"
BEFORE="${TARGET_DATE} 23:59:59"

declare -a sections=()
while IFS= read -r git_dir; do
  repo_dir="${git_dir%/.git}"
  repo_name=$(basename "$repo_dir")
  commits=$(git -C "$repo_dir" log --oneline \
    --after="$AFTER" --before="$BEFORE" \
    --all --no-merges 2>/dev/null || true)
  [[ -z "$commits" ]] && continue
  section="## ${repo_name}"$'\n'
  while IFS= read -r line; do
    section+="- ${line}"$'\n'
  done <<< "$commits"
  sections+=("$section")
done < <(find "$SEARCH_ROOT" -maxdepth 3 -name ".git" -type d | sort)

[[ ${#sections[@]} -eq 0 ]] && exit 0

{
  echo "# XP Quest - GitHub Commit Summary — ${TARGET_DATE}"
  echo ""
  for section in "${sections[@]}"; do
    echo "$section"
  done
} > "$OUTPUT_FILE"
