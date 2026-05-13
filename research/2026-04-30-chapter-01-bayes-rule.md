# Research notes — Chapter 01: Bayes' Rule and Bayesian Inference

## Source folders used
- Primary: `Bayes_Rule/Bayes_Rule.md`

## Source sections kept
- `## Introduction to Bayes's Rule` (3–392) — definitions, applications overview
- `## Theoretical Foundations` (393–484) — formula, prior/likelihood/posterior/evidence
- `## Bayesian Inference and Reasoning` (485–679)
- `## Applications → Medical Diagnosis` (756–813) — informs worked example
- `## Bayesian Computational Methods → MCMC, ABC, Bayesian Networks` (888–1137)
- `## Challenges → Choosing Priors, Computational Complexity, Interpretation` (1138–1275)
- `## Advanced Topics → Bayesian Decision Theory` (1575–1640)

## Source sections cut
- `## Bayesian Methods in Deep Learning` — magazine
- `## Future Directions for Bayesian Statistics` — speculative
- `## Further Reading and Resources` — companion page

## Original Claude content (NOT in source)

### Conjugate prior reference card framing
Source covers Beta-Binomial, Normal-Normal, Gamma-Poisson generally but not as a coordinated "three pairings cover most needs" reference move. Framing is Claude's; the pairings themselves are canonical.

### Specific software references
PyMC, Stan, NUTS algorithm reference. [verify] specific solver capabilities and version-specific claims.

### Worked example — medical test
Standard Bayesian-reasoning worked example. Per outline.md: "A real medical-test-interpretation case (positive test for a low-base-rate disease) showing how the prior dominates the posterior even with high test sensitivity." Used the canonical 99% sensitivity / 99% specificity / 0.001 base rate parameters. The arithmetic is correct.

### Bernstein-von Mises theorem mention
Standard convergence result; cited with [verify] for attribution.

### Inverse fallacy framing
The misconception "test gives a 99% posterior" → conflating P(+|D) with P(D|+) is the canonical inverse fallacy. Framing is Claude's but the phenomenon is widely-canonical.

### Decision rules table
Constructed by Claude. Each row reflects standard practice but the assembly into a single decision matrix is original.

## Factual claims preserved from source
- Bayes' rule formula and components — direct from source
- Prior/likelihood/posterior/evidence terminology — direct from source
- MCMC, ABC, Bayesian Networks — from source
- Hierarchical Bayesian models, non-parametrics, decision theory — from source
- Medical diagnosis application framing — from source

## [verify] count
2 inline `[verify]` markers:
1. NUTS / Hamiltonian Monte Carlo used by Stan and PyMC
2. Bernstein-von Mises theorem attribution

(Total: 2 — relatively low because Bayes' rule itself is canonical and the worked example uses standard textbook numbers.)

## Structure-drift checks
- Section 1 titled "Recognition pattern" ✓
- Section 2 titled "What you need to know first" ✓
- Decision rules table present ✓
- Worked example: medical test interpretation (named in outline.md) ✓
- Failure modes engages "Bayesian methods require a strong prior" ✓
- Anti-capability paragraph present ✓
- Capability statement closes the chapter ✓
- No exercises ✓
- No learning objectives ✓
- No chapter-opening hook ✓

## Voice-anchoring notes
- The opening section uses "Three signals" diagnostic structure parallel to Vol. 1's Recognition pattern shape.
- Resisted re-deriving Bayes' rule on the page beyond the formula statement. Reference convention.
- Worked example arithmetic is shown step-by-step because this is the chapter's most error-prone topic for practitioners. Reference convention plus explicit pedagogy in the canonical numerical example.
- The misconception engagement is unusually nuanced because the misconception itself has multiple layers (requires-strong-prior vs prior-dominates-posterior). Treated each layer separately.

## Word count
~3,030 words (target: ~3,000; within +1%)

## Open issues for editor
- Bernstein-von Mises citation could be more specific
- Software-stack mention (PyMC, Stan) should be verified for current version state
- Decision rules table is dense (10 rows); could split if Kindle layout requires

## Cross-reference verification
Verified against `books/algorithms-by-bear-vol1/outline.md`:
- Vol. 1 Ch 12 (Randomized Algorithms) ✓ — referenced for probability foundations
