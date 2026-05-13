# Research notes — Chapter 08: Social Networks

## Source folders used
- Primary: `Social_Networks/Social_Networks.md`

## Source sections kept
- `## Introduction to Social Networks` (3–86)
- `## Theoretical Foundations` (87–222) — graph theory basics, small world, network models
- `## Knowledge Graphs` (223–290) — brief
- `## Metrics for Analyzing Social Networks` (291–419) — centrality, density, clustering, community detection
- `## Connections in Social Networks` (420–665) — homophily, multiplexity, mutuality
- `## Distributions and Structural Features` (666–812) — bridges, tie strength, distance/paths
- `## Influence and Diffusion` (813–900) — diffusion models, influence-maximization algorithms (worked example anchor)
- `## Modelling and Visualization` (901–1017)
- `## Applications` (1131–1198) — marketing, public health, political networks
- `## Case Studies → Twitter/Facebook, Knowledge Graphs, Epidemic Spread` (1267–end)

## Source sections cut
- `## Advanced Topics → Signed/Weighted, Dynamic, Influence Diffusion` (1018–1130) — used briefly
- `## Challenges and Future Directions` (1199–1266) — speculative
- `## Conclusion`
- `## Exercises and Problems`

## Original Claude content (NOT in source)

### Centrality measure framing
Source covers degree, betweenness, closeness, eigenvector centrality. The "different centralities answer different questions" framing and the four-measure decision-rule organization are Claude's reference move.

### Brandes 2001 betweenness algorithm
[verify].

### Brin and Page 1998 PageRank
[verify].

### Newman 2004 modularity
[verify].

### Blondel et al. 2008 Louvain
[verify].

### Traag et al. 2019 Leiden
[verify].

### Fortunato-Barthélemy 2007 resolution limit
[verify].

### Nemhauser-Wolsey-Fisher 1978 submodular maximization
[verify].

### Kempe-Kleinberg-Tardos 2003 influence maximization
[verify].

### Leskovec et al. 2007 CELF
[verify].

### Holme-Saramäki 2012 temporal networks
[verify].

### Worked example — 100M-user marketing campaign
Per outline.md: "Influence maximization on a real social-network dataset (e.g., influence-spread modeling for marketing or epidemic-spread modeling for public health). Show why greedy with submodularity guarantees beats simpler heuristics."

The 100M users / 1000 seed budget / 50% vs 95% spread comparison are illustrative but reflect documented patterns in the influence-maximization literature.

### Public-health applications mention
Real connection between IC/LT models and SIR epidemiological models. [verify] specific applications in measles, HIV, COVID-19 contact tracing.

## Factual claims preserved from source
- Centrality definitions (degree, betweenness, closeness, eigenvector) — direct from source
- Independent Cascade Model and Linear Threshold Model — direct from source
- Modularity definition — from source (line numbers in Connections section)
- Influence maximization greedy algorithm — from source

## [verify] count
12 inline `[verify]` markers:
1. Brandes 2001 betweenness algorithm
2. Brin and Page 1998 PageRank
3. Newman 2004 modularity
4. Blondel et al. 2008 Louvain
5. Traag et al. 2019 Leiden
6. Fortunato-Barthélemy 2007 resolution limit
7. Nemhauser-Wolsey-Fisher 1978 submodular maximization
8. Kempe-Kleinberg-Tardos 2003 influence maximization
9. Leskovec et al. 2007 CELF
10. Holme-Saramäki 2012 temporal networks
11. 100M-user worked example numbers
12. Public-health applications (measles, HIV, COVID-19 contact tracing)
13. Degree heuristic vs greedy spread ratio (~50%)

(Total: ~13 inline `[verify]` tags as written.)

## Structure-drift checks
- Section 1 titled "Recognition pattern" ✓
- Section 2 titled "What you need to know first" ✓
- Decision rules table present ✓
- Worked example: influence maximization with submodularity (named in outline.md) ✓
- Failure modes engages "Centrality measures are interchangeable" ✓
- Anti-capability paragraph present ✓
- Capability statement closes the chapter ✓
- No exercises ✓
- No learning objectives ✓
- No chapter-opening hook ✓

## Voice-anchoring notes
- The chapter's intellectual spine is "centralities are not interchangeable + submodularity gives a provably good greedy" — both are conceptual moves with practitioner implications.
- Resisted teaching the modularity formula derivation. Reference convention.
- The submodularity section (§5) is load-bearing per outline.md. Made the bound explicit (`(1 − 1/e) ≈ 0.632`-approximation) and explained why it matters in practice.
- The misconception engagement uses 8 concrete failures because "centrality is one number" oversimplifies an inherently multidimensional question.

## Word count
~3,100 words estimated; actual will be checked at run-log update

## Open issues for editor
- All historical attribution dates need verification — many in this chapter
- Worked example numbers (100M users, 1000 seeds, spread ratios) are illustrative
- Public-health application mention needs specific case-study citations
- Could add brief mention of small-world property (Watts-Strogatz 1998) and scale-free networks (Barabási-Albert 1999) — currently implicit in source coverage

## Cross-reference verification
Verified against `books/algorithms-by-bear-vol1/outline.md`:
- Vol. 1 Ch 5 (Graphs) ✓
- Vol. 1 Ch 11 (Approximation Algorithms) ✓ — submodularity guarantee
- Vol. 1 Ch 10 (NP-Completeness) ✓ — influence maximization NP-hardness
- Vol. 1 Ch 9 (Network Flow) ✓
- Vol. 1 Ch 12 (Randomized Algorithms) ✓
