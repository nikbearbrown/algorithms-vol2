# Figure brief — Chapter 07: Randomness and Networking

## Recommended figures

### Figure 1 — Random walk on a graph
**Path:** `../images/chapter-7-random-walk.jpg`
**Description:** Small graph with vertex thicknesses proportional to stationary distribution `deg(v)/(2m)`. Sequence of arrows showing one realized random walk path. Caption: "Stationary distribution converges regardless of starting point."
**Use:** referenced in §4 (Random walks on networks).

### Figure 2 — Consistent hashing circle
**Path:** `../images/chapter-7-consistent-hashing-circle.jpg`
**Description:** Circular hash space with nodes (large circles) and keys (small dots) placed around it. Each key arrow points clockwise to its owning node. Below: "Add a node" — node inserted; only keys in its arc move. Caption: "Adding/removing nodes moves O(K/N) keys, not O(K)."
**Use:** referenced in §6 (Worked example) and §5 (Randomized routing and load balancing).

### Figure 3 — Power of two choices
**Path:** `../images/chapter-7-power-of-two-choices.jpg`
**Description:** Two histograms of load distribution. Left: random one-choice (max load `≈ log n / log log n`). Right: random two-choice (max load `≈ log log n`). Same number of balls and bins; dramatically different tail.
**Use:** referenced in §5 (Randomized routing).

### Figure 4 — Gossip propagation rounds
**Path:** `../images/chapter-7-gossip-rounds.jpg`
**Description:** Four-panel sequence. Round 0: one node has the update. Round 1: roughly 2 nodes. Round 2: roughly 4. Round t: 2^t until saturation, then logarithmic-time saturation. Caption: "Updates reach all nodes in O(log n) rounds with high probability."
**Use:** referenced in §5 (Gossip protocols).

### Figure 5 — Shortest-path vs random routing under load
**Path:** `../images/chapter-7-routing-comparison.jpg`
**Description:** Two-panel network diagram with same source-sink pair routing many requests. Left: shortest-path — central node congested. Right: Valiant random routing through random intermediates — load spread across the network. Caption: "Adversarial scheduling defeats shortest-path; randomization spreads."
**Use:** referenced in §8 (Failure modes — engaging the misconception).

## Inline figure-call markers
None inserted in current draft.
