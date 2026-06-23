#!/bin/zsh
# Evening run (default 17:30): sync today's activity → write the review file.
# Invoked by launchd (minimal env), so set PATH explicitly and self-locate the project root.
set -uo pipefail

export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
ROOT="${0:A:h:h}"                       # this script lives at $ROOT/bin/evening.sh
[ -f "$ROOT/config.env" ] && source "$ROOT/config.env"
: "${X_HANDLE:?set X_HANDLE in $ROOT/config.env}"
LOG="$ROOT/logs"
TODAY="$(date +%F)"
mkdir -p "$LOG" "$ROOT/reviews" "$ROOT/data"

echo "=== evening run $(date) ===" >> "$LOG/evening.log"

# Likes via birdclaw (bird transport).
{ birdclaw sync likes --mode bird --limit 100 --refresh; } >> "$LOG/evening.sync.log" 2>&1 \
  || echo "(birdclaw sync non-zero; continuing)" >> "$LOG/evening.log"

# Your OWN posts via bird directly (birdclaw's `sync authored` is xurl-only; bird's
# `user-tweets` fetches your profile timeline free over cookies — posts, not replies).
bird user-tweets "$X_HANDLE" -n 50 --json > "$ROOT/data/authored.json" 2>> "$LOG/evening.sync.log" \
  || echo "(bird user-tweets failed — review falls back to likes only)" >> "$LOG/evening.log"

claude -p "$(cat "$ROOT/prompts/evening.md")

CONTEXT: today is $TODAY. Use this exact date for <TODAY>." \
  --add-dir "$ROOT" \
  --permission-mode acceptEdits \
  --settings "$ROOT/.claude/settings.json" \
  >> "$LOG/evening.log" 2>> "$LOG/evening.err"

if [ -f "$ROOT/reviews/review-$TODAY.md" ]; then
  osascript -e "display notification \"Daily review ready → reviews/review-$TODAY.md (add your comments)\" with title \"ai-signal\" sound name \"Glass\""
else
  osascript -e "display notification \"Evening run finished but no review — check logs/evening.err\" with title \"ai-signal\""
fi
