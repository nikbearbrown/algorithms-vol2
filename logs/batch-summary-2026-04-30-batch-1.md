# Batch Summary — Vol. 2 Batch 1 (Chapters 1–5)

**Drafted:** 2026-04-30
**Drafter:** Claude (sonnet)
**Total words this batch:** 12,962
**Total `[verify]` count this batch:** 28

---

## Chapters drafted

| Ch | Slug | Word count | Target | Δ | `[verify]` |
| --- | --- | --- | --- | --- | --- |
| 01 | bayes-rule | 2,702 | 3,000 | −10% | 2 |
| 02 | optimal-stopping | 2,465 | 2,500 | −1% | 1 |
| 03 | explore-exploit | 2,605 | 3,000 | −13% | 9 |
| 04 | game-theory | 2,757 | 3,200 | −14% | 8 |
| 05 | scheduling | 2,433 | 2,800 | −13% | 8 |

All within ±20% of target. Average underrun is ~10%; consider whether editorial wants any chapter expanded with additional canonical examples.

## `[verify]` count, sorted descending

1. **Ch 03 — Explore vs Exploit** (9). Algorithm-attribution dates (Auer-Cesa-Bianchi-Fischer 2002, Lai-Robbins 1985, Agrawal-Goyal 2012, Russo-Van Roy 2014, Li et al. 2010); production-system claims (Yahoo, Google, Netflix, Amazon Thompson sampling); UCB1 constant; CTR worked-example numerics.

2. **Ch 04 — Game Theory** (8). Algorithm-attribution dates (Nash 1950, Daskalakis-Goldberg-Papadimitriou 2009, Myerson 1981, Axelrod tit-for-tat); production claims (VCG in spectrum auctions, 2019 Google first-price switch); behavioral economics empirics.

3. **Ch 05 — Scheduling** (8). Historical attributions (Graham 1966 / 1979, Liu-Layland 1973, Johnson 1954, Lenstra-Shmoys-Tardos 1990, Garey-Johnson-Sethi 1976); Linux CFS internals.

4. **Ch 01 — Bayes' Rule** (2). NUTS / HMC in Stan and PyMC; Bernstein-von Mises theorem.

5. **Ch 02 — Optimal Stopping** (1). Longstaff-Schwartz 2001.

The `[verify]` distribution roughly mirrors the chapter's reliance on canonical algorithmic-result attributions versus formula-derived material. Bayes' rule and the secretary problem are mathematically self-contained; bandit theory and game theory carry extensive literature attributions.

---

## Source-routing decisions

Vol. 2 has clean one-to-one folder-to-chapter mapping for these five chapters:

- Ch 1 ← `Bayes_Rule/`
- Ch 2 ← `Optimal_Stopping/`
- Ch 3 ← `Explore_Exploit/`
- Ch 4 ← `Game_Theory/` (absorbed auction/mechanism content per reconciled outline)
- Ch 5 ← `Scheduling/`

The auction/mechanism-design content that was originally planned for a Ch 9 (now removed) lives in Ch 4. Specifically: the four canonical auction formats (first-price, second-price, English, Dutch), VCG mechanism, revelation principle, and the Myerson revenue-equivalence theorem. The chapter is more compact on these topics than a standalone chapter would have been but covers what a practitioner needs to read auction-mechanism literature.

No cross-routing across folders for this batch (Game_Theory and Stable_Matching content split is in Ch 4 + Ch 6, but Ch 6 is in Batch 2).

---

## Structure-drift self-check (per chapter)

For each chapter: (a) Section 1 titled "Recognition pattern"; (b) chapter ends with anti-capability + capability paragraphs; (c) chapter has no exercises, no learning objectives, no chapter-opening hook.

| Ch | (a) Section 1 | (b) Anti-cap + cap close | (c) No forbidden structures |
| --- | --- | --- | --- |
| 01 | "Recognition pattern" ✓ | ✓ | ✓ |
| 02 | "Recognition pattern" ✓ | ✓ | ✓ |
| 03 | "Recognition pattern" ✓ | ✓ | ✓ |
| 04 | "Recognition pattern" ✓ | ✓ | ✓ |
| 05 | "Recognition pattern" ✓ | ✓ | ✓ |

**All pass.** One forbidden-word grep hit (Ch 2 line 53, "options that can be exercised") was a verb form, not the exercise-noun — false positive.

No structural drift detected.

---

## Voice-drift self-check

**Re-read of Section 1 of Chapter 1 (first):** "Three signals. *You have prior information.* You start with a belief..." Direct opening, signal-driven diagnostic, practitioner framing. Reference voice held.

**Re-read of Section 1 of Chapter 5 (last):** "Three signals. *Tasks, resources, and an objective.* Tasks have running times, deadlines, priorities, dependencies..." Same shape. Direct, concrete, reference-book tone.

**Comparative check across the batch:** the "Three signals" diagnostic structure is uniform across all five chapters — a stronger convergence than Vol. 1 Batch 1 had. Voice is consistent: practitioner addressing, no scene-setting, decision-rule-first, "you" not "we."

The chapter most at risk for textbook drift was Ch 1 (Bayes' Rule). The medical-test worked example is famously instructive and the temptation is to lecture. Held to reference voice — the arithmetic is shown step-by-step because it's the canonical numerical example and the workings are what most practitioners get wrong, but framing remains "here is the calculation" rather than "let me explain why this matters."

The chapter most at risk for source-faithful coverage was Ch 4 (Game Theory). The auction/mechanism-design content absorbed from the removed Ch 9 had to be compact while still covering VCG, the four canonical formats, strategy-proofness, and revelation principle. Solution: a single dense section (§6 Information and Bayesian games) that covers the auction taxonomy with strategic-equivalence relationships, plus the worked example using ad-auction reserve prices. Compact but complete.

No voice drift detected.

---

## Cross-reference integrity check

All cross-references resolve to chapters in `outline.md` (Vol. 2) or `books/algorithms-by-bear-vol1/outline.md` (Vol. 1).

| Source ch | Cross-refs to | Status |
| --- | --- | --- |
| 01 | Vol. 1 Ch 12; Vol. 2 Ch 2, 3, 4 | ✓ |
| 02 | Vol. 1 Ch 8, 12; Vol. 2 Ch 1, 3, 5 | ✓ |
| 03 | Vol. 1 Ch 12; Vol. 2 Ch 1, 2; magazine | ✓ |
| 04 | Vol. 1 Ch 2, 10, 13; Vol. 2 Ch 1, 2, 3, 6, 8 | ✓ |
| 05 | Vol. 1 Ch 2, 3, 5, 10, 11, 12, 13 | ✓ |

All 28 cross-references resolve. Forward references to Vol. 2 Ch 6 (Stable Matching) and Ch 8 (Social Networks) point at chapters drafted in Batch 2.

---

## Open issues for the editor

1. **Word counts ran consistently 10-14% under target** for four of five chapters. Could expand any of them with additional canonical examples, but the chapters are structurally complete. Decision deferred to editorial.

2. **Ch 4 absorbed auction/mechanism-design content from a removed Ch 9.** The coverage is compact. If the editor wants more auction depth, the current treatment can be expanded into a two-section split or a separate chapter could be reinstated.

3. **Bandit production-system claims (Ch 3)** — Yahoo news recommendation, Google search ranking, Netflix thumbnails, Amazon recommendations using Thompson sampling. All widely-cited but specific implementation details should be verified before publication.

4. **Game theory historical attributions (Ch 4)** — Nash 1950, Myerson 1981, Daskalakis-Goldberg-Papadimitriou 2009, Axelrod tournaments. All canonical but specific publication years and venues should be verified.

5. **Scheduling historical attributions (Ch 5)** — same pattern: Graham 1966 / 1979, Liu-Layland 1973, Johnson 1954, Lenstra-Shmoys-Tardos 1990, Garey-Johnson-Sethi 1976. All canonical, all need cross-check.

6. **Bayes' rule worked example (Ch 1)** uses the canonical 99% sensitivity / 99% specificity / 0.001 base rate — these are illustrative. If a real medical-screening case study is preferred, it could replace the canonical numbers.

7. **Linux CFS internals reference (Ch 5)** is brief. Could expand with virtual-time mechanism details if length permits.

---

## Files produced this batch

- `chapters/2026-04-30-chapter-01-bayes-rule.md`
- `chapters/2026-04-30-chapter-02-optimal-stopping.md`
- `chapters/2026-04-30-chapter-03-explore-exploit.md`
- `chapters/2026-04-30-chapter-04-game-theory.md`
- `chapters/2026-04-30-chapter-05-scheduling.md`
- `research/2026-04-30-chapter-01-bayes-rule.md`
- `research/2026-04-30-chapter-02-optimal-stopping.md`
- `research/2026-04-30-chapter-03-explore-exploit.md`
- `research/2026-04-30-chapter-04-game-theory.md`
- `research/2026-04-30-chapter-05-scheduling.md`
- `figures/2026-04-30-chapter-01-bayes-rule-brief.md`
- `figures/2026-04-30-chapter-02-optimal-stopping-brief.md`
- `figures/2026-04-30-chapter-03-explore-exploit-brief.md`
- `figures/2026-04-30-chapter-04-game-theory-brief.md`
- `figures/2026-04-30-chapter-05-scheduling-brief.md`
- `logs/source-chapter-map.md` (one-time map)
- `logs/drafting-run-log.csv`
- `logs/batch-summary-2026-04-30-batch-1.md` (this file)

---

## Next batch starting chapter

**Vol. 2 Batch 2 starts at Chapter 06 — Stable Matching and Gale-Shapley.**

Chapters in Batch 2 (final batch): 06 (Stable Matching), 07 (Randomness and Networking), 08 (Social Networks). Three chapters, not five.

**Heads-up for Batch 2:**

- **Ch 6 source folder is essentially empty** — `Stable_Matching_and_the_Gale-Shapley_Algorithm/README.md` is 31 lines of lesson outlines only. No body content. Same situation as Vol. 1's NP-Completeness chapter (Ch 10). The chapter must compose primarily from canonical stable-matching knowledge anchored to Gale-Shapley 1962, Roth 1984, Roth-Peranson 1999, and Abdulkadiroğlu-Sönmez 2003. Expect highest [verify] count of any chapter in Vol. 2.

- **Ch 7's "and Networking" half** is not strongly represented in source. The networking-specific content (random walks for routing, gossip protocols, distributed-systems load balancing including Cassandra-style consistent hashing) requires Claude composition with [verify] discipline.

- **Ch 8 has substantial source** — Social_Networks.md is the longest single-chapter source file in Vol. 2. Influence-maximization with submodularity guarantees (per outline.md worked example) is well-supported in source.

After Batch 2, the prompt's Section 10 final summary is generated.
