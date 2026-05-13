# Batch Summary — Vol. 2 Batch 2 (Chapters 6–8, FINAL BATCH)

**Drafted:** 2026-04-30
**Drafter:** Claude (sonnet)
**Total words this batch:** 7,766
**Total `[verify]` count this batch:** 34

---

## Chapters drafted

| Ch | Slug | Word count | Target | Δ | `[verify]` |
| --- | --- | --- | --- | --- | --- |
| 06 | stable-matching | 2,656 | 2,500 | +6% | 12 |
| 07 | randomness-and-networking | 2,597 | 2,800 | −7% | 9 |
| 08 | social-networks | 2,513 | 2,800 | −10% | 13 |

All within ±20%. Ch 6 ran slightly over target — the "fairness" misconception engagement and the NRMP redesign worked example earned the extra space.

## `[verify]` count, sorted descending

1. **Ch 08 — Social Networks** (13). Algorithm-attribution dates (Brandes 2001, Brin-Page 1998, Newman 2004, Blondel 2008, Traag 2019, Fortunato-Barthélemy 2007, Nemhauser-Wolsey-Fisher 1978, Kempe-Kleinberg-Tardos 2003, Leskovec 2007, Holme-Saramäki 2012); worked-example numerics; public-health applications.

2. **Ch 06 — Stable Matching** (12). As flagged in Batch 1 — source folder was 31-line README only. Heaviest reliance on canonical Gale-Shapley / Roth literature. Every theorem, every NRMP/school-choice fact, every strategy-proofness result is `[verify]`-flagged.

3. **Ch 07 — Randomness and Networking** (9). Algorithm attributions (Valiant 1982, Mitzenmacher 2001, Karger 1997, Demers 1987, Brin-Page 1998, Perozzi 2014, Grover-Leskovec 2016); production-system claims (Cassandra/Riak/Akka gossip use); worked-example consistent-hashing numerics.

The `[verify]` distribution reflects the predictable pattern: chapters with sparse source carry historical-attribution loads; chapters with substantial source still accumulate verify markers from algorithm-attribution work. Ch 8 is the highest in Batch 2 despite having the most substantial source — influence-maximization literature has more dated attributions than even stable matching.

---

## Source-routing decisions

This batch had two notable source-routing situations:

- **Ch 6 (Stable Matching) — source folder is 31-line README** with lesson outlines only, no body content. The chapter was composed primarily from canonical stable-matching knowledge anchored to Gale-Shapley 1962, Roth 1982 / 1986, Roth-Peranson 1999, Abdulkadiroğlu-Sönmez 2003. Highest fabrication risk in Vol. 2.

- **Ch 7 (Randomness and Networking) — networking-half mismatch.** Source covers randomness theory comprehensively but has minimal coverage of networked applications. The networking-specific content (consistent hashing, gossip protocols, Valiant routing, network embedding) required substantial Claude composition with `[verify]` discipline.

- **Ch 8 (Social Networks) — clean one-to-one source match.** Social_Networks.md is the longest single-chapter source file in Vol. 2 and covers the chapter's content well.

The Game_Theory and Stable_Matching folders that were flagged in source-chapter-map.md as potentially routing to a Ch 9 — that potential routing was resolved in Batch 1 by absorbing the auction/mechanism-design content into Ch 4 directly. Ch 6 in this batch did not need additional auction/mechanism material; the strategy-proofness coverage uses the matching-specific Roth result.

---

## Structure-drift self-check (per chapter)

| Ch | (a) Section 1 title | (b) Anti-cap + cap close | (c) No forbidden structures |
| --- | --- | --- | --- |
| 06 | "Recognition pattern" ✓ | ✓ | ✓ |
| 07 | "Recognition pattern" ✓ | ✓ | ✓ |
| 08 | "Recognition pattern" ✓ | ✓ | ✓ |

**All pass.** Zero forbidden-word grep hits in this batch (Batch 1 had two false positives; Batch 2 had none).

No structural drift detected.

---

## Voice-drift self-check

**Re-read of Section 1 of Chapter 6 (first):** "Three signals. *Two distinct populations with preferences over each other.* Applicants rank programs..." Direct opening, signal-driven diagnostic, names canonical examples, sets up the misconception trap. Reference voice held.

**Re-read of Section 1 of Chapter 8 (last):** "Three signals. *The data is relationships.* Followers, friends, collaborators..." Same shape, same discipline. Direct, concrete, practitioner-addressing.

**Comparative check across the batch:** the "Three signals" diagnostic structure remains uniform. Voice held throughout: practitioner addressing, no scene-setting, decision-rule-first, "you" not "we." This convergence is consistent with Batch 1.

The chapter most at risk for fabrication-driven drift was Ch 6 (Stable Matching) — empty-ish source. Resisted the temptation to compose freely; anchored every claim to a `[verify]` attribution. The Gale-Shapley algorithm is mathematically precise; the strategy-proofness asymmetry is a Roth 1982 result; the NRMP history has documented dates.

The chapter most at risk for source-mismatch drift was Ch 7 (Randomness and Networking) — the source's "networking" coverage was thin. Anchored the chapter's networking material to canonical distributed-systems and randomized-algorithms references. The result is more compositional than the other Vol. 2 chapters but stays within the canonical literature.

No voice drift detected.

---

## Cross-reference integrity check

All cross-references resolve to chapters in `outline.md` (Vol. 2) or `books/algorithms-by-bear-vol1/outline.md` (Vol. 1).

| Source ch | Cross-refs to | Status |
| --- | --- | --- |
| 06 | Vol. 1 Ch 2, 5, 9, 10; Vol. 2 Ch 4 | ✓ |
| 07 | Vol. 1 Ch 3, 5, 9, 12; Vol. 2 Ch 1 | ✓ |
| 08 | Vol. 1 Ch 5, 9, 10, 11, 12; Vol. 2 Ch 7 | ✓ |

All in-batch cross-references resolve.

---

## Open issues for the editor (this batch)

1. **Ch 6 is the highest-risk chapter in Vol. 2.** Source folder was effectively empty. Every reduction, every theorem attribution, every NRMP/school-choice fact must be cross-verified against canonical references. Roth's *The Economics of Matching* would be the standard verification source.

2. **Ch 7's networking-specific content is composed from canonical distributed-systems knowledge.** The consistent-hashing worked example, gossip-protocol coverage, Valiant routing, and network-embedding mentions all need cross-checking against current implementations and original papers.

3. **Ch 8's influence-maximization framing assumes the IC/LT/SIR model unification.** The connection between social-network diffusion and epidemic models is widely-cited but specific public-health applications (measles, HIV, COVID-19 contact tracing) need case-study citations.

4. **Submodularity and the `(1 − 1/e)` approximation guarantee** appears in both Vol. 1 Ch 11 (approximation algorithms) and Vol. 2 Ch 8 (influence maximization). The cross-reference structure is correct; editorial may want to ensure the two chapters don't redundantly state the bound or contradict each other.

---

## Files produced this batch

- `chapters/2026-04-30-chapter-06-stable-matching.md`
- `chapters/2026-04-30-chapter-07-randomness-and-networking.md`
- `chapters/2026-04-30-chapter-08-social-networks.md`
- `research/2026-04-30-chapter-06-stable-matching.md`
- `research/2026-04-30-chapter-07-randomness-and-networking.md`
- `research/2026-04-30-chapter-08-social-networks.md`
- `figures/2026-04-30-chapter-06-stable-matching-brief.md`
- `figures/2026-04-30-chapter-07-randomness-and-networking-brief.md`
- `figures/2026-04-30-chapter-08-social-networks-brief.md`
- `logs/drafting-run-log.csv` (appended)
- `logs/batch-summary-2026-04-30-batch-2.md` (this file)
- `logs/drafting-run-final-summary.md` (volume-wide final report)

---

## End of Vol. 2 drafting run

All 8 chapters drafted. The volume-wide final summary at `logs/drafting-run-final-summary.md` carries the cross-reference integrity, structure conformance, misconception engagement, anti-capability, worked-example, and systemic-issues checks per Section 10 of the drafting prompt.

After this batch, every chapter's status in `outline.md` is `drafted`. The next stage is editorial review.
