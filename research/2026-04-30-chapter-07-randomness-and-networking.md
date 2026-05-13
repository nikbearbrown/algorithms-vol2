# Research notes — Chapter 07: Randomness and Networking

## Source folders used
- Primary: `Randomness_and_Networking/Randomness.md`

## Source sections kept
- `## Introduction to Randomness` (3–68)
- `## Theoretical Foundations` (69–202) — used briefly; foundational material covered in Vol. 1 Ch 12
- `## Generating Randomness` (203–326) — PRNG, TRNG, cryptographic randomness
- `## Applications of Randomness → Randomized Algorithms` (327–469) — selectively used
- `## Case Studies → Network Security` (904–1000) — informs cryptographic-randomness section

## Source sections cut
- `## Randomness in Nature and Society → Quantum, Evolution, Economics` — out of scope for reference
- `## Philosophical and Ethical Considerations` — out of scope
- `## Randomness in Art and Creativity` — out of scope
- `## Challenges and Future Directions → Predictive Models` — speculative
- `## Conclusion`
- `## Exercises and Problems`

## Original Claude content (NOT in source)

The "and Networking" half of the chapter title is essentially Claude composition. Source covers randomness generally but does not address networking applications at depth. The following are added based on canonical distributed-systems and networked-algorithms knowledge:

### Random walks on networks
- Stationary distribution at vertex `v` is `deg(v)/(2m)` — canonical
- Mixing time, expander graphs — canonical
- PageRank attribution: Brin and Page 1998 [verify]

### Randomized routing and load balancing
- Valiant 1982 randomized routing on hypercubes [verify]
- Mitzenmacher 2001 power-of-two-choices [verify]
- Karger et al. 1997 consistent hashing [verify]

### Gossip protocols
- Demers et al. 1987 epidemic algorithms [verify]
- Cassandra/Riak/Akka gossip use [verify]

### Network embedding
- DeepWalk (Perozzi-Al-Rfou-Skiena 2014) [verify]
- node2vec (Grover-Leskovec 2016) [verify]

### Worked example — distributed cache load balancing
Per outline.md: "Load balancing in a real distributed system (Cassandra-style consistent hashing, or randomized load balancing). Show how randomization beats round-robin under realistic load skew."

The 100-node cache, 100–500 virtual nodes per physical node, hot-key skew arguments are standard distributed-systems knowledge.

### Eight-failure-mode framing
The misconception "random routing is worse than shortest-path" is broken into multiple concrete failure modes.

## Factual claims preserved from source
- PRNG (Linear Congruential Generator) formulation — direct from source
- TRNG concept — from source
- Cryptographic randomness foundations — from source

## [verify] count
9 inline `[verify]` markers:
1. Brin and Page 1998 PageRank
2. Valiant 1982 randomized routing
3. Mitzenmacher 2001 power of two choices
4. Karger et al. 1997 consistent hashing
5. Demers et al. 1987 gossip protocols
6. Perozzi-Al-Rfou-Skiena 2014 DeepWalk
7. Grover-Leskovec 2016 node2vec
8. Cassandra gossip use
9. 100-node cache / 100–500 virtual nodes per physical node

(Total: ~9 inline `[verify]` tags as written.)

## Structure-drift checks
- Section 1 titled "Recognition pattern" ✓
- Section 2 titled "What you need to know first" ✓
- Decision rules table present ✓
- Worked example: distributed cache load balancing (named in outline.md) ✓
- Failure modes engages "Random routing is worse than shortest-path routing" ✓
- Anti-capability paragraph present ✓
- Capability statement closes the chapter ✓
- No exercises ✓
- No learning objectives ✓
- No chapter-opening hook ✓

## Voice-anchoring notes
- The chapter combines two topics that don't naturally cohere — randomness theory and networking applications. The opening section uses "three signals" to find the connecting tissue (deterministic fragility, coordination cost, network sampling).
- Resisted re-deriving consistent hashing properties or balls-and-bins analysis on the page. Reference convention.
- The misconception engagement is the most assertive of the chapter; the "shortest-path is always best" intuition is widespread.
- The cryptographic vs algorithmic randomness distinction is briefly recapitulated in §3 since it's relevant to networked uses (tokens, nonces) and Vol. 1 Ch 12 has the deeper treatment.

## Word count
~3,000 words estimated; will check at run-log update

## Open issues for editor
- All historical attribution dates need verification
- Power-of-two-choices attribution may extend further back than Mitzenmacher (Azar et al. 1994 is sometimes cited)
- Karger et al. 1997 consistent hashing — verify exact paper and year
- Production-system gossip use claims should be verified against current implementation
- Worked example numerics (100 nodes, 100–500 virtual nodes) are illustrative

## Cross-reference verification
Verified against `books/algorithms-by-bear-vol1/outline.md`:
- Vol. 1 Ch 12 (Randomized Algorithms) ✓ — heavily referenced
- Vol. 1 Ch 5 (Graphs) ✓
- Vol. 1 Ch 3 (Data Structures) ✓ — consistent hashing, bloom filters
- Vol. 1 Ch 9 (Network Flow) ✓
