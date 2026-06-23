---
name: ai-signal-pipeline
description: Build a local, read-only daily AI/LLM screening pipeline for X/Twitter — birdclaw + bird as the data layer, headless Claude as the brain. Scaffolds the wrappers, prompts, a learning taste file, a launchd schedule, and a self-contained HTML team slide. Use when the user wants a daily AI-trends digest from X that screens for genuine production-grade signal, runs unattended, and never posts. It screens; it never writes.
user-invokable: true
license: MIT
metadata:
  author: kitchen-engineer42
  version: "0.1.0"
  category: productivity
---

# ai-signal-pipeline

Scaffold a personalized, **read-only** daily pipeline that screens X/Twitter for the genuine,
most important AI/LLM developments. **birdclaw + bird are the data layer; you (headless Claude)
are the brain.** Two deliverables: a personal markdown **digest** and a self-contained HTML
**team slide**. It learns from the user's comments and runs unattended via launchd.

You are acting as an **installer**: walk the user through the steps below, scaffold their project
from `templates/` (filling placeholders), test it, and schedule it. Do the work; don't just
describe it. Ask the few questions in Step 4, then proceed.

## What it builds
```
$PIPELINE_ROOT/
├── bin/{morning,evening}.sh     # launchd wrappers (sync → claude -p → notify)
├── prompts/{morning,evening,slide,taste-update}.md
├── .claude/settings.json        # READ-ONLY permission model (writes to X blocked)
├── config.env                   # X_HANDLE
├── taste.md                     # screening criteria that learns from comments
├── brand/tokens.css             # slide palette (customizable)
├── vendor/frontend-slides/      # slide generator (installed, not bundled)
└── digests/ slides/ reviews/ comments/ data/ logs/
```
Morning (default 07:00): sync → ingest comments → conservative taste-update → build YESTERDAY's
team slide → screen TODAY → write `digests/<today>.md`. Evening (17:30): review the user's X
activity + a comment slot. The user's comments next morning tune taste AND get quoted in the slide.

## The read-only promise (state this to the user up front)
The pipeline reads the user's X session **cookies locally** via `bird` (graphql). `.claude/settings.json`
allows only bird READ commands and **blocks every write** (tweet/reply/follow/unfollow/unbookmark).
It screens; it never posts, follows, or likes. Nothing leaves the machine except the web searches
Claude runs and the Claude API calls for screening.

## Step 1 — Prerequisites (macOS)
Confirm/install: Homebrew, Node, Claude Code. Then:
```bash
brew install steipete/tap/birdclaw && birdclaw init
npm install -g @steipete/bird
```
(birdclaw is MIT; bird is @steipete/bird. We install them — we don't redistribute them.)

## Step 2 — Connect X (read-only, free)
Use `bird`, NOT `xurl`: bird reads your logged-in browser session over graphql — no developer
app, no paid API. (`xurl` needs the X developer API; X *Premium* is a consumer sub and does not
grant API access.)
- Make sure the user is **logged into x.com in Chrome** (Safari cookies are often locked by macOS;
  bird falls back to Chrome automatically).
- Verify: `bird whoami` → prints their handle. Capture the handle (without `@`) for `config.env`.

## Step 3 — Install the slide generator (don't bundle it)
The slide step uses `frontend-slides` (MIT, by zarazhangrui). Install it into the project's
`vendor/`:
```bash
git clone --depth 1 https://github.com/zarazhangrui/frontend-slides.git "$PIPELINE_ROOT/vendor/frontend-slides"
```

## Step 4 — Scaffold the project (ask these, then build)
Ask the user (use a structured question UI if available):
1. **Project root** — absolute path. **Must NOT be under ~/Desktop, ~/Documents, or ~/Downloads**
   (macOS TCC blocks background launchd jobs from those folders). Recommend `~/ai-signal`.
2. **X handle** — default to `bird whoami`'s answer.
3. **Focus areas / run times** — defaults are fine (production AI/LLM; 07:00 / 17:30).

Then scaffold from this skill's `templates/`:
- Copy [templates/bin/morning.sh](templates/bin/morning.sh) and [templates/bin/evening.sh](templates/bin/evening.sh) → `$PIPELINE_ROOT/bin/` (`chmod +x`). They self-locate their root; no path edits needed.
- Copy the four [templates/prompts/](templates/prompts/) files → `$PIPELINE_ROOT/prompts/`.
- Copy [templates/settings.json](templates/settings.json) → `$PIPELINE_ROOT/.claude/settings.json`.
- Copy [templates/taste.md](templates/taste.md) → `$PIPELINE_ROOT/taste.md` and [templates/brand/tokens.css](templates/brand/tokens.css) → `$PIPELINE_ROOT/brand/tokens.css`.
- Copy [templates/config.env](templates/config.env) → `$PIPELINE_ROOT/config.env` and set `X_HANDLE`.
- Render the launchd templates → `~/Library/LaunchAgents/`: copy [templates/launchd/morning.plist.tmpl](templates/launchd/morning.plist.tmpl) and [templates/launchd/evening.plist.tmpl](templates/launchd/evening.plist.tmpl), replacing `__PIPELINE_ROOT__` with the real absolute root (and run times if changed).
- `mkdir -p` the `digests slides reviews comments data logs` subfolders.

## Step 5 — Customize
- Edit `taste.md`: tune **Focus areas**, trusted sources, and optionally pin a **Preferred List**
  (`bird lists` to find one). This is the screening brain.
- Optionally edit `brand/tokens.css` to the user's palette (the slide locks to it).
- Optional **brand-coach**: only if the user keeps a posting voice/brand guide — point the evening
  prompt at it; otherwise it stays off.

## Step 6 — Dry-run test
```bash
cd "$PIPELINE_ROOT" && ./bin/morning.sh
cat digests/$(date +%F).md      # good digest?
cat logs/morning.err            # errors?
```
Day 1 has no "yesterday," so it skips the slide/taste steps and just builds today's digest.

## Step 7 — Schedule + smoke test
```bash
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/sh.ai-signal.morning.plist
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/sh.ai-signal.evening.plist
launchctl list | grep ai-signal
```
**Smoke test the unattended path** (the one thing an interactive run can't prove): schedule a
throwaway job ~2 minutes out that runs `bird whoami` + a trivial `claude -p` + writes a marker
file, then inspect its log. If a macOS **Keychain** prompt appears (background job reading Chrome
cookies / the Claude token), the user clicks **Allow** once. If it completes clean, it's settled —
tomorrow's 07:00 run is the same path doing the real work.

## Gotchas (hard-won; bake these in)
- **bird, not xurl.** X Premium ≠ API access; the dev API is paid. bird (cookies) is free + read-only.
- **`bird user-tweets` returns posts, not replies.** The brand-coach works off posts; reply-level
  tracking isn't available without the paid API. Don't promise it.
- **Keep the project OFF ~/Desktop/Documents/Downloads.** macOS TCC blocks background launchd jobs
  from writing there — the interactive run works but the scheduled one fails silently. Use `~/ai-signal`.
- **`bird news --ai-only` leaks** sports/entertainment; screen against taste and drop non-AI items.
- **Cookies expire.** When reads start failing, re-run `bird whoami` after re-logging into Chrome.
- **Mac must be awake + logged in** at the scheduled times (launchd catches a missed run on wake).
