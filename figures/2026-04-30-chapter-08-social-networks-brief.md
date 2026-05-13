# Figure brief — Chapter 08: Social Networks

## Recommended figures

### Figure 1 — Four centrality measures on the same graph
**Path:** `../images/chapter-8-centrality-comparison.jpg`
**Description:** Same small graph (~20 vertices) shown four times. Vertices sized by: (1) degree centrality, (2) betweenness centrality, (3) closeness centrality, (4) PageRank/eigenvector centrality. Different vertices are largest in each panel. Caption: "Same network, different rankings — centralities answer different questions."
**Use:** referenced in §3 (Centrality) and §8 (Failure modes).

### Figure 2 — Modularity-based community detection
**Path:** `../images/chapter-8-louvain-communities.jpg`
**Description:** Karate-club-style network with vertices colored by detected communities (Louvain output). Modularity score annotated. Caption: "Modularity = within-community edge excess over random."
**Use:** referenced in §4 (Community detection).

### Figure 3 — IC vs LT diffusion models
**Path:** `../images/chapter-8-diffusion-models.jpg`
**Description:** Two side-by-side network diagrams. Left: Independent Cascade — each edge has activation probability `p`; one node activates a neighbor probabilistically. Right: Linear Threshold — node activates when sum of weighted active neighbors exceeds its threshold. Same network, different diffusion patterns shown.
**Use:** referenced in §5 (Influence and diffusion).

### Figure 4 — Greedy influence maximization vs heuristic
**Path:** `../images/chapter-8-influence-max-comparison.jpg`
**Description:** Plot. X-axis: seed budget `k`. Y-axis: expected spread. Two curves: greedy with submodularity (close to optimal); degree heuristic (significantly worse for large `k`). Annotation showing `(1 − 1/e)` lower bound.
**Use:** referenced in §5 and §7 (Worked example).

### Figure 5 — Submodularity intuition
**Path:** `../images/chapter-8-submodularity.jpg`
**Description:** Two scenarios. Left: adding seed `v` to a small set increases spread by `Δ_1`. Right: adding the same seed `v` to a larger set (containing the small set) increases spread by `Δ_2 ≤ Δ_1`. Caption: "Diminishing returns. Greedy gets `1 − 1/e` of optimal."
**Use:** referenced in §5 (Influence and diffusion).

## Inline figure-call markers
None inserted in current draft.
