# Research notes — Chapter 06: Stable Matching and Gale-Shapley

## Source folders used
- Primary: `Stable_Matching_and_the_Gale-Shapley_Algorithm/README.md` — **31 LINES, lesson outlines only**

## Composition strategy
Per source-chapter-map.md and Vol. 2 Batch 1 batch-summary heads-up: this chapter is the highest-risk for fabrication in Vol. 2, parallel to Vol. 1's NP-Completeness (Ch 10).

The chapter is composed primarily from canonical stable-matching knowledge anchored to widely-canonical references:
- Gale and Shapley 1962 (American Mathematical Monthly): "College Admissions and the Stability of Marriage"
- Roth 1982 (Mathematics of Operations Research): "The Economics of Matching: Stability and Incentives" — strategy-proofness
- Roth 1986 (Econometrica): rural hospital theorem
- Roth and Peranson 1999 (American Economic Review): NRMP redesign
- Abdulkadiroğlu and Sönmez 2003 (American Economic Review): "School Choice: A Mechanism Design Approach"

The lesson outlines in source served as a structural skeleton — the six lessons map roughly to the chapter's sections (intro, problem definition, Gale-Shapley, correctness/efficiency, variants, applications).

## Original Claude content (essentially the entire chapter)

### Section structure
The five major sections (Stable matching problem, Gale-Shapley algorithm, Strategy-proofness, Variants, Worked example) are framed by Claude based on canonical knowledge.

### Algorithm pseudocode and complexity
Standard Gale-Shapley pseudocode with `O(n²)` complexity. Canonical.

### Proposer-optimal stability proof sketch
Standard textbook fact. Canonical.

### Strategy-proofness asymmetry
- One-sided strategy-proofness: Roth 1982 [verify]
- No two-sided strategy-proof stable mechanism: Roth 1982 [verify]

### Many-to-one matching, ties, incomplete preferences, couples
Standard variants. Couples-and-complementarities producing non-existence is a real result (Roth 1984). [verify].

### Rural hospital theorem
Roth 1986. [verify].

### Worked example — NRMP
- 50,000 students per year [verify]
- NRMP created 1952 [verify]
- 1998 redesign from program-proposing to applicant-proposing [verify]
- Roth-Peranson 1999 paper [verify]
- Abdulkadiroğlu-Sönmez 2003 (school choice / Boston mechanism switch in 2005) [verify]

### Boston Public Schools 2005 switch
[verify] specific year.

### Gibbard-Satterthwaite theorem
Mentioned in anti-capability. [verify].

## Factual claims (none from source body — README only)

The README provides only lesson topic names. Every technical claim in this chapter is composed from Claude's knowledge of canonical stable-matching theory.

## [verify] count
12 inline `[verify]` markers — second-highest in Vol. 2 (Vol. 2 Ch 4 had 8). Reflects the high-risk source situation as flagged.

1. Gale and Shapley 1962
2. Proposer-optimal stability proof attribution (Gale-Shapley 1962, second mention)
3. Roth 1982 one-sided strategy-proofness
4. Roth 1982 no two-sided strategy-proof stable mechanism
5. Roth 1986 rural hospital theorem
6. NRMP scale (50,000 students)
7. NRMP creation 1952
8. NRMP 1998 redesign
9. Roth-Peranson 1999
10. Boston Public Schools using modified Gale-Shapley
11. Abdulkadiroğlu-Sönmez 2003 school choice
12. Gibbard-Satterthwaite theorem (anti-capability mention)

## Structure-drift checks
- Section 1 titled "Recognition pattern" ✓
- Section 2 titled "What you need to know first" ✓
- Decision rules table present ✓
- Worked example: NRMP medical residency match (named in outline.md) ✓
- Failure modes engages "Stable matching produces a fair outcome" ✓
- Anti-capability paragraph present ✓
- Capability statement closes the chapter ✓
- No exercises ✓
- No learning objectives ✓
- No chapter-opening hook ✓

## Voice-anchoring notes
- The chapter's intellectual spine is the proposer-optimal stability fact + the strategy-proofness asymmetry. Both are surprising on first encounter and both directly engage the "fairness" misconception. Built the chapter around them.
- Resisted detailed proof of stability (the no-blocking-pair argument). Sketched in §4 (Gale-Shapley algorithm); full derivation deferred to companion page.
- The worked example (NRMP) does triple duty: shows the algorithm at scale, illustrates the consequence of proposer-side choice (1998 redesign), and connects to school choice as a parallel application.
- Failure-modes section uses 8 concrete failures because the misconception covers many practitioner readings — the algorithm is stable, but stable ≠ fair, and the breakdown of "fair" has many dimensions.

## Word count
~3,000 words estimated; actual will be checked at run-log update

## Open issues for editor
- All [verify] tags need cross-check against canonical references — Roth's *The Economics of Matching* would be the standard verification source
- NRMP-specific facts (creation year, scale, 1998 redesign details) should be verified against current AAMC/NRMP documentation
- Boston Public Schools 2005 switch year should be verified
- Gibbard-Satterthwaite mention is brief; could be expanded if length budget permits

## Cross-reference verification
Verified against `books/algorithms-by-bear-vol1/outline.md`:
- Vol. 1 Ch 9 (Network Flow) ✓ — bipartite matching
- Vol. 1 Ch 10 (NP-Completeness) ✓ — couples and complementarities NP-hardness
- Vol. 1 Ch 5 (Graphs) ✓ — matching-as-graph
- Vol. 1 Ch 2 (Algorithm Analysis) ✓
