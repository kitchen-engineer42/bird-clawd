You are building ONE self-contained HTML slide deck — a daily team brief of the day's AI signal:
the specific information and the owner's takes, presented for a team to read. Internal. Work fully
autonomously and HEADLESS. End after writing the .html file.

PROJECT ROOT: passed via --add-dir ($ROOT). The wrapper appends dates.

## What goes in the deck — and what NEVER does
The team sees ONLY the day's AI content and the takes on it:
- **IN:** each item's topic + the **specific, source-grounded information**; the owner's comment on
  that item (verbatim).
- **OUT (never on a team slide):** anything about building/operating the pipeline or tuning taste;
  the **suggested-follows** list; any overall "editor's note" aggregation; the freeform
  `comments/<date>.md` and the evening review (internal, not for the team).
If a comment is about the pipeline/taste/process rather than the item's substance, omit it.

## HEADLESS rules
Do NOT ask questions, generate previews, open a browser, deploy, or export PDF. Generate the final
deck directly. Audience: busy teammates reading on a screen.

## Step 1 — Learn the slide system
Read from `$ROOT/vendor/frontend-slides/`: `SKILL.md`, `html-template.md`, `animation-patterns.md`,
and `viewport-base.css` (include its FULL contents inline; fixed 1920×1080 stage; `class="slide"`,
`.active`/`.visible`). Skim `STYLE_PRESETS.md` for a calm, editorial layout.

## Step 2 — Lock the palette to the brand
Read `$ROOT/brand/tokens.css` and lock the deck's `:root` colors to it — identical every day, so
every deck looks consistent. Keep the palette **restrained and purposeful** (a neutral ground, one
structural color, one attention accent); don't introduce colors outside the tokens. Distinctive
non-generic fonts via Google Fonts with a system-sans fallback so it degrades offline.

## Step 3 — Readability is the priority
This is READ by a team on a screen — comfortable, not cramped:
- **Large type** at the 1920×1080 stage: item headline ≥ 46px, body/brief ≥ 32px, comment ≥ 30px.
- **1–2 items per slide, never more.** Prefer more slides over smaller type.
- **Fill the stage** — no large empty regions; enlarge type or give content more room instead.

## Step 4 — Gather + ground the content
- Items: the **Top posts and Long reads** in `$ROOT/digests/<YESTERDAY>.md` (NOT suggested follows).
  If it doesn't exist, write nothing and exit.
- Per-item comments: the inline `💬` lines under each item → render as a distinct comment callout,
  verbatim, clearly the owner's voice, visually separate from the neutral content. Default to a
  CALM accent (a light/secondary brand color) so long comments stay readable; RESERVE the strongest
  accent for comments flagged important (the `💬` line starts with `!`/`‼️`) — the loud color is for
  the 1–2 that matter per day, not every comment. Drop any meta/process comment.
- **Ground each item in its SOURCE — do NOT parrot.** WebFetch each link and read enough of the
  source to convey real substance (the brief is a pointer); if unreachable, say so rather than
  inventing. Frame the item from the source; the take sits alongside, never as the slide's own
  understanding.
- **Clickable jump-to-source (REQUIRED).** Every item MUST carry a real link to its source:
  `<a href="<full https URL>" target="_blank" rel="noopener">…↗</a>`, in an accent color with a ↗
  glyph. The `href` is the FULL canonical URL — the `<url>` line under that item in the digest —
  even if the visible text is shortened. The team must be able to tap through; NO bare-text URLs.

## Step 5 — Deck structure
1. **Title:** the deck name in ONE consistent display font — the name alone is the brand; no
   per-word color/italic treatment, no decorative motif/logo. + "<YESTERDAY> · daily team brief".
   Small mark: "Internal — not for external distribution."
2. **Content slides:** 1–2 items each — topic, @author/source, the specific source-grounded info,
   the link, then the owner's comment callout for that item. NO editor's-note slide, NO suggested
   follows, NO meta.
3. **Closing:** the deck mark + date.
**Layout safety:** the kicker / title / source line must NEVER overlap the content. Use normal
top-down flow; on any flex region that vertically centers content, use `justify-content: safe center`
(not plain `center`) so a two-line headline can't push centered content up into the header.
**Fit the stage (no bottom overflow):** every slide must fit ENTIRELY within the 1920×1080 stage —
nothing crosses the bottom edge. If content would overflow, shrink that slide's type a notch and
tighten gaps until it fits, or move a comment onto its own slide.
Never overflow a slide — split into more slides instead.

## Visual conventions (LIGHT starting point — refine over your first week)
Patterns that read well. Follow loosely and VARY — don't reproduce identical slides; a floor,
not a mold. Review the output and tune to taste.
- **Top bar** per content slide: a kicker left ("Top post N · <tag>" / "Long read · <tag>") + a
  slide index "N / <total>" right; a thin rule under it.
- **Headline** in the display font; **source line** under it carrying the clickable jump-to-source link.
- **Body:** 1–2 items. Data-heavy items → a row of big **stat cards** (figure + label); otherwise
  a left **content column** + right **comment column(s)**.
- **Footer:** small "<deck name> · <date>". **Closing:** deck name + a one-line "what to watch".

## Step 6 — Write the file
Single self-contained `.html`, ALL CSS/JS inline, full `viewport-base.css`, relative links,
`/* === SECTION === */` comments. Write to `$ROOT/slides/<YESTERDAY>.html`. No preview files. End.
