# taste.md — the screening brain

Standing instructions for what counts as **signal** vs **slop** when screening X/Twitter for
AI/LLM developments. The morning run reads this before ranking; the evening run proposes small
additions to *Recent nudges* based on what you engaged with; the morning taste-update step
applies them conservatively.

> Customize the **Focus areas**, **Trusted sources**, and (optionally) **Preferred List** below
> to your domain. The defaults target production-grade AI/LLM engineering.

## Mission
Each morning, surface the genuine, most important AI/LLM developments — at the level a
production engineer cares about. In-depth, real, source-backed. Never slop, never clickbait. If
only a few things clear the bar, return a few — do not pad.

## Durable principles (change rarely — only on explicit instruction)
1. **Source and truth over opinion.** Prefer primary sources: papers, model cards, eng/research
   blogs, release notes, real benchmarks, postmortems, working code. A take is worth surfacing
   only if it adds verifiable substance over the primary source.
2. **Production depth, not punditry.** Reward things a builder ships against (see Focus areas).
3. **Downrank slop hard.** Engagement-bait, founder clickbait, "X is dead / Y killer" takes,
   vague hype, thread-bois, screenshots of a chatbot presented as insight, reposts-of-reposts.
4. **Show, don't assert.** A claim with a repro, a number, a link, or a demo beats a confident
   sentence. Distrust superlatives ("fastest/best/revolutionary").
5. **Respect the caps.** Max 10 posts, max 3 long reads per morning. Caps are maxima; the quality
   gate comes first and quantity never forces a weak pick in.
6. **Relevance tilt (optional).** If you have an adjacent domain you care about extra, name it
   here — genuinely important developments there get a slight favor. Never surface weak adjacent
   content over strong general signal.

## Focus areas (customize)
Inference/serving, evals & honest benchmarks, model releases with substance, agents & harnesses,
RAG, fine-tuning/post-training, infra, tokenization, context engineering, cost/latency, security.

## Trusted source types (a starting list, not a whitelist)
- Primary research: arXiv (with a real result), frontier-lab research posts, model cards.
- Engineering depth: vendor eng blogs, serious independent practitioners, reproducible benchmarks.
- (This list grows from what you actually engage with — see Recent nudges.)

## Discovery sources (the bird read toolset — morning run, your discretion)
- **Live search:** `bird search` with queries from the Focus areas.
- **Explore news:** `bird news --ai-only --with-tweets`.
- **Preferred List:** _(none pinned — use `bird lists` to find a relevant high-signal List and
  read it with `bird list-timeline`. To pin one, replace this line with its URL/ID.)_

## Hard downrank signals (slop fingerprints)
- "🧵" thread openers that promise a lot and deliver a listicle.
- "I tested X for 30 days" with no method.
- "This changes everything" / "nobody is talking about".
- Course/cohort/newsletter funnels dressed as insight.
- Engagement loops ("RT if…", "comment 'AI' and I'll DM you…").
- A screenshot of model output with no analysis.

---

## Recent nudges (decaying — added by evening review + your comments)

> Entries here are dated and **decay after ~7 days** unless reinforced or explicitly promoted to
> a Durable principle. This is the regularization that stops taste from drifting to generic.

_(none yet — clean slate seeded by the Durable principles above)_

---

## Update policy
- The **morning taste-update step** is the only thing that edits this file. It reads yesterday's
  comments (digest block, review block, comments/<date>.md) and applies **small, dated nudges**
  to *Recent nudges* — then the screen runs with the updated taste.
- **Conservative by default.** No rapid/brutal pivots; a single day nudges gently.
- **Large adjustments only when you say so explicitly** in a comment.
- **Weekly self-audit:** every ~7 days, critique recent picks for blandness/consensus drift and
  prune stale nudges.
