#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<EOF
Usage: $(basename "$0") --from DATE [--to DATE]

Runs github_summary.sh for each date in the given range (inclusive).

Options:
  --from DATE   Start date (required)
  --to DATE     End date (optional, defaults to today)
  -h, --help    Show this help message

Date formats accepted:
  YYYY-MM-DD       2026-04-21
  MM/DD/YYYY       04/21/2026
  DD Mon YYYY      21 Apr 2026
  "last monday"    any expression understood by GNU date -d

Examples:
  $(basename "$0") --from 2026-04-21
  $(basename "$0") --from 2026-04-21 --to 2026-04-29
  $(basename "$0") --from "last monday" --to yesterday
EOF
}

parse_date() {
  local input="$1" label="$2"
  local result
  if ! result=$(date -d "$input" +%Y-%m-%d 2>/dev/null); then
    echo "Error: invalid $label date '$input'." >&2
    echo "Run $(basename "$0") --help for accepted date formats." >&2
    exit 1
  fi
  echo "$result"
}

FROM=""
TO=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --from)   FROM="${2:-}"; shift 2 ;;
    --to)     TO="${2:-}";   shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "$FROM" ]]; then
  echo "Error: --from is required." >&2
  usage
  exit 1
fi

FROM=$(parse_date "$FROM" "--from")
TO=$(parse_date "${TO:-today}" "--to")

if [[ $(date -d "$FROM" +%s) -gt $(date -d "$TO" +%s) ]]; then
  echo "Error: --from ($FROM) must not be after --to ($TO)." >&2
  exit 1
fi

current="$FROM"
while [[ $(date -d "$current" +%s) -le $(date -d "$TO" +%s) ]]; do
  echo "Processing $current..."
  "$SCRIPT_DIR/daily_git_summary.sh" "$current" && echo "  done" || echo "  skipped (no commits)"
  current=$(date -d "$current + 1 day" +%Y-%m-%d)
done
