You are building ONE self-contained HTML slide deck — yesterday's AI-signal digest wrapped with
the owner's commentary — to forward to a team. Work fully autonomously and HEADLESS. End after
writing the .html file.

PROJECT ROOT: passed via --add-dir (referred to below as $ROOT). The wrapper appends dates.

## HEADLESS rules (override the slide skill's interactive flow)
You are NOT in a conversation:
- Do NOT ask questions, generate style previews, open a browser, deploy, or export PDF. Go
  straight to generating the final deck.
- Pre-decided: Purpose = internal team brief; Density = high / reading-first; Content = ready.

## Step 1 — Learn the slide system
Read from `$ROOT/vendor/frontend-slides/` (installed during setup):
- `SKILL.md`, `html-template.md`, `animation-patterns.md`.
- `viewport-base.css` — include its FULL contents inline (fixed 1920×1080 stage; slides use
  `class="slide"`, `.active`/`.visible` switching).
- `STYLE_PRESETS.md` (+ `bold-template-pack/selection-index.json` if present) — pick ONE calm,
  authoritative editorial layout. Don't read a bold template's full `design.md` unless you commit.

## Step 2 — LOCK the palette to the brand tokens
Read `$ROOT/brand/tokens.css`. Whatever layout you pick, OVERRIDE its colors in `:root` with
these tokens, identical every day. Typography: follow frontend-slides' guidance (distinctive,
non-generic) and load via Google Fonts, but keep a system sans fallback so the file still
degrades gracefully offline after emailing.

## Step 3 — Gather yesterday's content + comments
- Source: `$ROOT/digests/<YESTERDAY>.md`. If it doesn't exist, write nothing and exit.
- Comments (quote VERBATIM — candid/internal is fine; this deck is internal):
  - the "## My comments" block in `$ROOT/digests/<YESTERDAY>.md`
  - the "YOUR COMMENTS" block in `$ROOT/reviews/review-<YESTERDAY>.md`
  - `$ROOT/comments/<YESTERDAY>.md` (if present)
  Attach comments to specific items when an item number/author is referenced; else treat as an
  overall editor's note.

## Step 4 — Deck structure (high-density reading deck)
1. **Title:** "AI Signal — <YESTERDAY>", subtitle "Internal team brief". Small mark: "Internal —
   not for external distribution."
2. **Editor's note** (only if there's an overall comment): quote it in a prominent callout.
3. **Content slides:** the digest's Top posts + Long reads, grouped 2–3 per slide as cards
   (topic, @author/source, brief, link). Where the owner commented on an item, render the quote
   as a distinct **comment bubble/callout** in an accent color, visually separate from the
   neutral digest text.
4. **Closing:** a short "what to watch" line or the date + mark.
Respect density limits — never overflow a slide; split into more slides instead.

## Step 5 — Write the file
Single self-contained `.html`, ALL CSS/JS inline, full `viewport-base.css` included, relative
links only, `/* === SECTION === */` comments. Write to `$ROOT/slides/<YESTERDAY>.html`. No
preview files. End after writing.
