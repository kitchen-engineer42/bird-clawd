#!/bin/zsh
# deck2png — render a multi-slide deck HTML into ONE tall PNG (a scrolling poster).
# Phone/chat friendly: recipients just scroll the image, no slide nav needed.
# Zero extra deps — uses headless Chrome + macOS `sips`.
# Usage: bin/deck2png.sh <deck.html> [out.png] [phone_width]
#   phone_width defaults to 1920 (native, sharpest). Pass a smaller width for a lighter file.
set -uo pipefail
export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

HTML="${1:?usage: deck2png.sh <deck.html> [out.png] [phone_width]}"
OUT="${2:-${HTML%.html}.png}"
PHONEW="${3:-1920}"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
[ -x "$CHROME" ] || { echo "Google Chrome not found at: $CHROME"; exit 1; }
[ -f "$HTML" ] || { echo "no such file: $HTML"; exit 1; }

N=$(grep -cE '^[[:space:]]*<section class="slide' "$HTML")   # real tags only (skip comments)
[ "$N" -gt 0 ] || { echo "no <section class=\"slide\"> found in $HTML"; exit 1; }
H=$(( N * 1080 ))           # each slide is a fixed 1920×1080 stage
TMP="$(mktemp -d)"

# Build a "poster" copy: un-stack the fixed-stage overlay so every slide renders, stacked top-to-bottom.
python3 - "$HTML" "$TMP/stack.html" <<'PY'
import sys
src, out = sys.argv[1], sys.argv[2]
s = open(src).read()
override = """<style id="poster-override">
html,body{overflow:visible!important;height:auto!important;}
.deck-viewport{position:static!important;height:auto!important;overflow:visible!important;}
.deck-stage{position:static!important;transform:none!important;width:1920px!important;height:auto!important;}
.slide{position:relative!important;inset:auto!important;visibility:visible!important;opacity:1!important;
  pointer-events:auto!important;display:block!important;width:1920px!important;height:1080px!important;}
.reveal{opacity:1!important;transform:none!important;}
.deck-controls{display:none!important;}
</style>"""
s = s.replace('</head>', override + '</head>')
open(out, 'w').write(s)
PY

echo "rendering $N slides → one 1920x${H} poster (output width ${PHONEW}px) …"
"$CHROME" --headless --disable-gpu --hide-scrollbars --force-color-profile=srgb \
  --virtual-time-budget=8000 --window-size=1920,${H} \
  --screenshot="$TMP/full.png" "file://$TMP/stack.html" 2>/dev/null

[ -f "$TMP/full.png" ] || { echo "screenshot failed"; rm -rf "$TMP"; exit 1; }
# Native render is 1920px wide. Keep it as-is at >=1920 (sharpest); only downscale if asked for less.
if [ "$PHONEW" -ge 1920 ]; then
  cp "$TMP/full.png" "$OUT"
else
  sips --resampleWidth "$PHONEW" "$TMP/full.png" --out "$OUT" >/dev/null 2>&1 || cp "$TMP/full.png" "$OUT"
fi

# report final dimensions by reading the PNG IHDR (no deps)
DIM=$(python3 -c "import struct;d=open('$OUT','rb').read(24);w,h=struct.unpack('>II',d[16:24]);print(f'{w}×{h}')" 2>/dev/null || echo "?")
rm -rf "$TMP"
echo "done → $OUT  ($N slides, ${DIM}px)"
