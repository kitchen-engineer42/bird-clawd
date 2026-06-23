# AI Signal — 2026-01-15

_Screened against taste.md · source & truth over opinion · caps 10 posts / 3 long reads._
_(Example output with FICTIONAL accounts/topics — illustrates the format only.)_

## Top posts (6/10)
1. **Tessera runtime ships paged KV-cache quantization (NVFP4)** — @kvcache_io
   "This is the runtime lead, not a model drop." Quantized KV-cache for consumer GPUs; published
   the benchmark harness, so the throughput claim is checkable. The serving-side cost win.
   https://x.com/kvcache_io/status/1000000000000000001

2. **A production agent stack, layer by layer** — @harness_lab
   They optimized each layer — eval loop, agent harness + compaction, and post-trained the base
   model. Concrete "here's our actual stack," not "wrap an API." The highest-value category.
   https://x.com/harness_lab/status/1000000000000000002

3. **Benchmarking LLM serving across accelerator backends** — @serving_notes
   Portability numbers moving a workload from one backend to another; reproducible scripts attached.
   https://x.com/serving_notes/status/1000000000000000003

4. **Lumen-2 open weights: ~1/5 the cost of the frontier, LongTask-Bench 61** — NorthLab (primary)
   Kept because it carries real cost + coverage numbers. Leading with cost and the coding-agent
   figure, not the leaderboard-Elo framing.
   https://example.com/northlab/lumen-2

5. **Verification is the bottleneck once agents write most of the code** — @evalcrafter
   Postmortem: review/verification, not generation, became the constraint at scale — with a
   detection + rollback playbook.
   https://x.com/evalcrafter/status/1000000000000000005

6. **Ranking models by unique users, not token volume** — @latentloop
   Token-heavy models skew usage leaderboards; unique-user ranking is the more honest metric.
   https://x.com/latentloop/status/1000000000000000006

## Long reads (3/3)
- **The unit economics of LLM inference in 2026** — example.com (eng blog)
  Token cost from GPU-hour to per-request, with cache hit-rate and batching as the dominant levers.
  https://example.com/blog/llm-inference-economics
- **Calibrated retrieval beats bigger context on long documents** — arXiv-style preprint
  Controlled study: a tuned retriever + 32k beats naive 1M-context on accuracy and cost.
  https://example.com/papers/calibrated-retrieval
- **What a real agent harness looks like** — example.com
  Thin orchestrator, fat tools, deterministic replay — and where most "agent frameworks" overbuild.
  https://example.com/blog/agent-harness

## Suggested follows
- @harness_lab — ships real production agent stacks; eval-loop + harness depth, not hype.
- @kvcache_io — inference/runtime leads (KV-cache, quantization, serving PRs).
- @serving_notes — cross-backend serving benchmarks; systems-level depth.

## Note
The For You feed was mostly engagement-bait today, so most signal came from `bird search` +
Explore news — the beyond-follows layer doing its job. No taste nudge applied (clean slate).

---
## My comments
<!-- Jot your take on today's items here anytime — candid/internal is fine, this never gets
     posted to X. Next morning these (a) tune the taste and (b) get quoted in the team slide. -->

1 + 2 are the real signal — runtime wins and actual agent-stack breakdowns are what I want more
of. Demote the leaderboard framing on 4; keep it only because it has the cost number. Cut the
consumer-founder noise entirely.
