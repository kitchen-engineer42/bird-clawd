#!/bin/zsh
# Morning run (default 07:00). Sequence: sync → ingest comments & adjust taste →
# build YESTERDAY's team slide → fetch TODAY's digest → notify.
# Invoked by launchd (minimal env), so set PATH explicitly and self-locate the project root.
set -uo pipefail

export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
ROOT="${0:A:h:h}"                       # this script lives at $ROOT/bin/morning.sh
[ -f "$ROOT/config.env" ] && source "$ROOT/config.env"
: "${X_HANDLE:?set X_HANDLE in $ROOT/config.env}"
LOG="$ROOT/logs"
TODAY="$(date +%F)"
YESTERDAY="$(date -v-1d +%F)"           # BSD/macOS date
mkdir -p "$LOG" "$ROOT/digests" "$ROOT/slides" "$ROOT/comments" "$ROOT/data"

echo "=== morning run $(date) (today=$TODAY yesterday=$YESTERDAY) ===" >> "$LOG/morning.log"

run_claude () {  # $1 = prompt file
  claude -p "$(cat "$1")

CONTEXT: today is $TODAY, yesterday is $YESTERDAY. Use these exact dates for <TODAY>/<YESTERDAY>." \
    --add-dir "$ROOT" \
    --permission-mode acceptEdits \
    --settings "$ROOT/.claude/settings.json"
}

# 1) Refresh the local store (read-only, bird cookie transport).
{
  birdclaw sync timeline --mode bird --limit 200 --refresh
  birdclaw sync likes    --mode bird --limit 100 --refresh
} >> "$LOG/morning.sync.log" 2>&1 || echo "(birdclaw sync non-zero; continuing)" >> "$LOG/morning.log"

# Your follow graph (who you ALREADY follow) so suggested-follows can exclude them.
# birdclaw's `sync following` is dry-run unless --yes; bird's `following` fetches it directly.
bird following --all --max-pages 8 --json > "$ROOT/data/following.json" 2>> "$LOG/morning.sync.log" \
  || echo "(bird following failed — suggested-follows will be inferred)" >> "$LOG/morning.log"

# 2) taste-update + 3) yesterday's team slide — only if a yesterday digest exists.
if [ -f "$ROOT/digests/$YESTERDAY.md" ]; then
  run_claude "$ROOT/prompts/taste-update.md" >> "$LOG/morning.log" 2>> "$LOG/morning.err"
  run_claude "$ROOT/prompts/slide.md"         >> "$LOG/morning.log" 2>> "$LOG/morning.err"
  # Render the team slide into a tall scrolling PNG (phone/chat friendly). Tolerant.
  if [ -f "$ROOT/slides/$YESTERDAY.html" ]; then
    "$ROOT/bin/deck2png.sh" "$ROOT/slides/$YESTERDAY.html" "$ROOT/slides/$YESTERDAY.png" 1920 \
      >> "$LOG/morning.log" 2>&1 || echo "(deck2png failed; html slide still available)" >> "$LOG/morning.log"
  fi
else
  echo "(no digests/$YESTERDAY.md — skipping taste-update + slide on first run)" >> "$LOG/morning.log"
fi

# 4) Today's screening (uses the freshly-updated taste.md).
run_claude "$ROOT/prompts/morning.md" >> "$LOG/morning.log" 2>> "$LOG/morning.err"

# Ensure today has a freeform comment drop-file.
[ -f "$ROOT/comments/$TODAY.md" ] || \
  printf '# Comments — %s\n\n<!-- Drop any take here anytime. Reference a digest item by number.\n     Next morning this tunes taste and can be quoted in the team slide. -->\n' "$TODAY" \
  > "$ROOT/comments/$TODAY.md"

# 5) Notify — two deliverables.
SLIDE_MSG=""
[ -f "$ROOT/slides/$YESTERDAY.html" ] && SLIDE_MSG="Team slide for $YESTERDAY ready · "
if [ -f "$ROOT/digests/$TODAY.md" ]; then
  osascript -e "display notification \"${SLIDE_MSG}Today's digest ready → digests/$TODAY.md\" with title \"ai-signal\" sound name \"Glass\""
else
  osascript -e "display notification \"Morning run finished but no digest — check logs/morning.err\" with title \"ai-signal\""
fi
