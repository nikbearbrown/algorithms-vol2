# Research notes — Chapter 02: Optimal Stopping

## Source folders used
- Primary: `Optimal_Stopping/Optimal_Stopping.md`

## Source sections kept
- `## Introduction to Optimal Stopping` (3–65)
- `## Theoretical Foundations` (66–182) — secretary problem, probability framework
- `## Models and Strategies` (183–360) — classic secretary, marriage problem, real options
- `## Mathematical Framework` (361–474) — martingales, DP, Bellman equations
- `## Optimal Stopping in Finance and Economics` (475–613) — American options
- `## Computational Methods` (614–716) — Monte Carlo, ML approaches
- `## Practical Applications → Career` (843–905) — informs worked example
- `## Challenges and Limitations` (997–1145)

## Source sections cut
- `## Advanced Topics → Multi-stage, Bandits, Incomplete Info` (717–842) — bandits routed to Ch 3
- `## Future Directions → AI Integration` — speculative
- `## Practical Applications → Online Dating, Medical Decision Making` — kept brief
- `## Conclusion`
- `## Exercises and Problems`

## Original Claude content (NOT in source)

### "Three signals" diagnostic structure
Recognition pattern framing in §1 is Claude's standard reference move.

### Variant taxonomy
The taxonomy in §4 (full-info / value-max / house-buying / multiple offers / partial info / finance / deadlines) is a coordinated framing. Source covers each variant separately; the explicit taxonomy as a reference move is Claude's.

### Longstaff-Schwartz 2001 attribution
[verify] for American option pricing via regression Monte Carlo.

### Worked example — startup hiring with model critique
Per outline.md: "Hiring at a startup. The interviewing-pipeline problem mapped to the secretary problem, showing where it applies, where it doesn't (revisitable candidates, partial information about quality), and what the practitioner heuristic looks like." The structure (model assumptions, what it gets right, what it gets wrong, practitioner heuristic, where canonical theory fails) is Claude's framing. The 50-candidate / 3-month / 18-observation numbers are illustrative.

### "Stop at 37% of candidates" misconception engagement
Standard textbook misconception. Framing is Claude's.

## Factual claims preserved from source
- Classic secretary problem statement and `n/e` strategy — direct from source
- Marriage problem (Sultan's Dowry) — from source
- Real options analysis basics — from source
- Bellman equation structure — from source
- American options as optimal stopping — from source

## [verify] count
1 inline `[verify]` marker:
1. Longstaff-Schwartz 2001 (American option Monte Carlo via regression)

(Total: 1 — most chapter content is canonical optimal-stopping theory directly from source; little fabrication risk.)

## Structure-drift checks
- Section 1 titled "Recognition pattern" ✓
- Section 2 titled "What you need to know first" ✓
- Decision rules table present ✓
- Worked example: hiring at a startup mapped to secretary problem (named in outline.md) ✓
- Failure modes engages "37% rule means stop at 37% of candidates" ✓
- Anti-capability paragraph present ✓
- Capability statement closes the chapter ✓
- No exercises ✓
- No learning objectives ✓
- No chapter-opening hook ✓

## Voice-anchoring notes
- The "three signals" pattern in §1 carries the recognition discipline.
- Resisted re-deriving the `1/e` probability on the page. Stated the trade-off, named the result, deferred derivation.
- Worked example explicitly works through "model critique" — what the canonical theory assumes, where the assumptions break in production, what a practitioner heuristic looks like. This is the chapter's pedagogical move per outline.md note.
- Misconception engagement uses six concrete failure modes rather than just the headline misconception. Reference convention for showing the framework's depth.

## Word count
~2,640 words (target: ~2,500; within +6%)

## Open issues for editor
- Longstaff-Schwartz citation could be more specific (Review of Financial Studies, 2001)
- Real-world hiring numbers (50 candidates, 3 months, 18-observation) are illustrative
- The bandit cross-reference to Ch 3 could be tightened in editorial
- Decision rules table has 10 rows; layout for Kindle to be checked

## Cross-reference verification
Verified against `books/algorithms-by-bear-vol1/outline.md`:
- Vol. 1 Ch 8 (Dynamic Programming) ✓ — cited for DP framing of stopping
- Vol. 1 Ch 12 (Randomized Algorithms) ✓ — cited for randomness in random-order assumption
