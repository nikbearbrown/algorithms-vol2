# Research notes — Chapter 04: Game Theory

## Source folders used
- Primary: `Game_Theory/Game_Theory.md`

## Source sections kept
- `## Introduction to Game Theory` (3–115)
- `## Theoretical Foundations` (116–300) — players/strategies/payoffs, Nash equilibrium
- `## Classical Game Theory Models` (301–470) — Prisoner's Dilemma, Battle of Sexes, Chicken
- `## Strategic Moves and Dynamics` (471–597) — sequential, repeated, bargaining
- `## Information in Games` (598–722) — complete vs incomplete, signaling, Bayesian games
- **Auction case study** (629–722) — kept here per reconciled outline (not routed to a Ch 9 that no longer exists)
- `## Evolutionary Game Theory` (723–842) — brief
- `## Behavioral Game Theory` (875–989) — brief
- `## Network Games` (991–1158) — cross-ref to Ch 8
- `## Applications` (1159–1323)

## Source sections cut
- `## Advanced Topics in Game Theory` (1324+) — speculative
- `## Conclusion`
- `## Further Reading and Resources`

## Original Claude content (NOT in source)

### Auction format taxonomy (4 canonical formats + VCG + Revelation Principle)
Source covers some auction content (line 629+) but not the explicit four-format taxonomy or the strategic-equivalence relationships. Added.

### Specific algorithm/result attributions
- Nash 1950 existence theorem
- Daskalakis-Goldberg-Papadimitriou 2009 PPAD-completeness
- Myerson 1981 Revenue Equivalence Theorem and optimal auction
- Axelrod tit-for-tat tournament

All marked [verify].

### 2019 Google first-price auction switch
Per outline.md note. Real event but specific date and rationale should be verified.

### Worked example — three perspectives on platform pricing
Per outline.md: "Show how the same situation looks like a different game depending on what's modeled as a player." The three-perspective structure (platform-vs-users, platform-vs-competitor, drivers-as-strategic) is Claude's framing; the underlying models are canonical industrial-organization economics.

### Ride-sharing surge specifics
Surge wars, surge gaps, driver positioning. Real phenomena; specific empirical claims marked [verify].

### Behavioral game theory — Ultimatum Game numbers
"25–30% rejection threshold, 40–50% offered on average." Widely-canonical from experimental economics. [verify] specific meta-analyses.

## Factual claims preserved from source
- Game representation (players, strategies, payoffs) — direct from source
- Nash equilibrium definition and best-response algorithm — direct from source
- Prisoner's Dilemma payoff structure — direct from source
- Battle of the Sexes structure — direct from source
- Bayesian games framework — direct from source
- Auction case study (sealed-bid) — direct from source

## [verify] count
8 inline `[verify]` markers:
1. Nash 1950 existence theorem
2. Daskalakis-Goldberg-Papadimitriou 2009 PPAD-completeness
3. Myerson 1981 Revenue Equivalence
4. Axelrod tit-for-tat tournament results
5. VCG used in spectrum auctions / ad-allocation
6. Myerson 1981 (second mention, optimal-auction framework)
7. 2019 Google first-price auction switch
8. Ultimatum Game empirical thresholds

(Total: 8 inline `[verify]` tags.)

## Structure-drift checks
- Section 1 titled "Recognition pattern" ✓
- Section 2 titled "What you need to know first" ✓
- Decision rules table present ✓
- Worked example: pricing on a two-sided platform (named in outline.md) ✓
- Failure modes engages "Game theory always predicts rational behavior" ✓
- Anti-capability paragraph present ✓
- Capability statement closes the chapter ✓
- No exercises ✓
- No learning objectives ✓
- No chapter-opening hook ✓

## Voice-anchoring notes
- The chapter absorbed auction/mechanism-design coverage that was originally planned for the now-removed Ch 9. Treatment is more compact than a standalone chapter would have been but covers the canonical formats, the strategy-proofness argument, VCG, and revelation principle.
- Resisted teaching coalitional game theory and the Shapley value at depth — sketched only, deferred to companion page.
- The three-perspective worked example is the chapter's pedagogical move per outline.md note. Concrete, builds incrementally, shows how model-choice drives prediction.
- Misconception engagement uses six concrete failures, each anchored to a real strategic phenomenon.

## Word count
~3,290 words (target: ~3,200; within +3%)

## Open issues for editor
- All historical attribution dates need verification, especially Nash 1950, Myerson 1981, Daskalakis-Goldberg-Papadimitriou 2009
- 2019 Google first-price auction switch — verify specific date and product (display vs search)
- Ultimatum Game empirical thresholds — verify against current meta-analyses
- The PPAD-complete computational complexity claim deserves a clearer in-chapter statement of what PPAD is
- Decision rules table has 12 rows; layout for Kindle to be checked

## Cross-reference verification
Verified against `books/algorithms-by-bear-vol1/outline.md`:
- Vol. 1 Ch 13 (Linear Programming) ✓ — for two-player zero-sum games via LP
- Vol. 1 Ch 10 (NP-Completeness and Intractability) ✓ — for PPAD complexity
- Vol. 1 Ch 2 (Algorithm Analysis) ✓ — for Big O on game trees
