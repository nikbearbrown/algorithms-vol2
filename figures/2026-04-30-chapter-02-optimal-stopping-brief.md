# Figure brief — Chapter 02: Optimal Stopping

## Recommended figures

### Figure 1 — Secretary problem success probability vs observation length
**Path:** `../images/chapter-2-secretary-success-curve.jpg`
**Description:** Plot. X-axis: observation phase length `m` from 0 to `n`. Y-axis: probability of selecting the best candidate. Curve peaks at `m = n/e ≈ 0.368n` with success probability `≈ 1/e ≈ 0.368`. Caption: "Both halves work out to 1/e."
**Use:** referenced in §3 (Classic secretary problem).

### Figure 2 — Threshold sequences for variants
**Path:** `../images/chapter-2-threshold-sequences.jpg`
**Description:** Three side-by-side plots over time. Left: Classic secretary — flat threshold = best of observation phase, then accept first improvement. Middle: Value-maximization with deadline — decreasing threshold. Right: House-buying with search cost — flat threshold determined by cost.
**Use:** referenced in §4 (Variants).

### Figure 3 — Bellman backward induction tree
**Path:** `../images/chapter-2-bellman-tree.jpg`
**Description:** Tree showing time on horizontal axis, value/state on vertical. At each node, value = max(stop, continue). Optimal action highlighted at each node. Backward arrows show induction direction.
**Use:** referenced in §5 (DP framing).

### Figure 4 — Real-world hiring critique
**Path:** `../images/chapter-2-hiring-critique.jpg`
**Description:** Side-by-side comparison. Left: classical secretary problem assumptions. Right: real-world hiring assumptions (recall possible, noisy signals, non-iid arrival, unknown horizon). Annotations show how each violation changes the optimal strategy.
**Use:** referenced in §7 (Worked example).

### Figure 5 — American option exercise boundary
**Path:** `../images/chapter-2-american-option-boundary.jpg`
**Description:** Plot. X-axis: time to expiration. Y-axis: underlying asset price. Exercise boundary shown as a curve dividing "exercise region" (above for puts / below for calls) from "continuation region." Caption notes the boundary is the optimal-stopping rule.
**Use:** referenced in §4 (Variants).

## Inline figure-call markers
None inserted in current draft.
