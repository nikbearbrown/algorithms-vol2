# Algorithms by Bear, Vol. 2

**Author:** Nik Bear Brown

**Folder:** `books/algorithms-vol2-with-llms/`

---

## Overview

**Audience.** **Primary reader:** Working data scientist, ML engineer, or operations analyst. Encounters Bayesian-flavored problems, scheduling problems, A/B-testing-as-bandits problems, and game-theoretic reasoning in their work and wants a single reference covering the methods.

---

## Table of Contents

<!-- TOC sourced from `outline.md` -->

8 chapters, one per source folder. Each chapter's status is one of:
- `to write` — not yet drafted
- `drafted` — first draft complete
- `revised` — after editorial pass

When all chapters are `revised`, the book is ready for KDP submission.

## Chapter 01 — Bayes' Rule and Bayesian Inference
- **Status:** drafted
- **Length target:** ~3,000 words
- **Source folders:** `Bayes_Rule/`
- **Primary capability:** Apply Bayes' rule to update beliefs given evidence; recognize when a problem is Bayesian-shaped; choose between exact, conjugate, and approximate inference.
- **Secondary capabilities:** Identify priors, likelihoods, and posteriors in a real problem; recognize conjugate-prior families; diagnose when MCMC or variational methods are needed.
- **Anti-capability:** Not a treatment of probabilistic programming or modern Bayesian deep learning.
- **Misconception engaged:** "Bayesian methods require a strong prior."
- **Worked example:** A real medical-test-interpretation case (positive test for a low-base-rate disease) showing how the prior dominates the posterior even with high test sensitivity.
- **Companion-page handoffs:** Conjugate prior reference card. PyMC and Stan worked examples. MCMC diagnostics primer.
- **Cross-references:** Bayesian decision theory → Chapter 3 (explore/exploit). Probability foundations → Vol. 1 Chapter 12.
- **Notes:** Foundation chapter. Loaded with practitioner misconceptions; engage them concretely.

## Chapter 02 — Optimal Stopping
- **Status:** drafted
- **Length target:** ~2,500 words
- **Source folders:** `Optimal_Stopping/`
- **Primary capability:** Recognize when a problem is an optimal-stopping problem; apply the threshold rule for the secretary problem class; choose between full-information and partial-information variants.
- **Secondary capabilities:** Distinguish 37%-rule problems from house-buying problems; recognize when stopping-time analysis applies in finance.
- **Anti-capability:** No coverage of optimal control beyond classical optimal stopping.
- **Misconception engaged:** "The 37% rule means stop at 37% of candidates."
- **Worked example:** Hiring at a startup. The interviewing-pipeline problem mapped to the secretary problem, showing where it applies, where it doesn't (revisitable candidates, partial information about quality), and what the practitioner heuristic looks like.
- **Companion-page handoffs:** Variants of the secretary problem with code. Real-world stopping-time examples (parking, house-buying, quitting-while-ahead).
- **Cross-references:** Bayesian updating in stopping → Chapter 1. Sequential decisions → Chapter 3.

## Chapter 03 — Explore vs Exploit (Multi-Armed Bandits)
- **Status:** drafted
- **Length target:** ~3,000 words
- **Source folders:** `Explore_Exploit/`
- **Primary capability:** Choose between exploration and exploitation strategies (epsilon-greedy, UCB, Thompson sampling) for a given multi-armed bandit problem.
- **Secondary capabilities:** Recognize when a problem is bandit-shaped vs full-RL-shaped; apply contextual bandits when context matters; diagnose when bandits fail (non-stationary rewards, delayed feedback).
- **Anti-capability:** No coverage of full reinforcement learning. Bandit methods are the foundations; RL is in the magazine.
- **Misconception engaged:** "A/B testing and bandits are interchangeable."
- **Worked example:** Click-through-rate optimization at a real website. Show why classical A/B testing is wasteful, how UCB beats epsilon-greedy in low-noise cases, and where Thompson sampling wins.
- **Companion-page handoffs:** Bandit algorithm benchmarks. Contextual bandit implementations. Pointer to magazine RL issues.
- **Cross-references:** Bayesian foundations for Thompson sampling → Chapter 1. RL deep-dive → magazine.

## Chapter 04 — Game Theory
- **Status:** drafted
- **Length target:** ~3,200 words
- **Source folders:** `Game_Theory/` (includes auction and mechanism-design content — covered here, not deferred).
- **Primary capability:** Model a strategic interaction as a game; identify Nash equilibria for simple games; recognize when game-theoretic reasoning applies versus when it's overkill.
- **Secondary capabilities:** Distinguish cooperative from non-cooperative games; recognize zero-sum from general-sum; apply minimax for adversarial games; sketch second-price and VCG auctions when game-theoretic intuition demands them.
- **Anti-capability:** No deep treatment of mechanism design impossibility results. No evolutionary game theory.
- **Misconception engaged:** "Game theory always predicts rational behavior."
- **Worked example:** Pricing on a two-sided platform (Uber surge, ad-auction reserve prices). Show how the same situation looks like a different game depending on what's modeled as a player.
- **Companion-page handoffs:** Equilibrium computation tools. Auction-mechanism reference card. Pointer to magazine for dynamic-pricing deep-dives.
- **Cross-references:** Stable matching as game-theoretic mechanism → Chapter 6.

## Chapter 05 — Scheduling
- **Status:** drafted
- **Length target:** ~2,800 words
- **Source folders:** `Scheduling/`
- **Primary capability:** Model a scheduling problem; choose between exact algorithms (LP-based), heuristics (list scheduling, EDF), and approximation (LP relaxation, primal-dual).
- **Secondary capabilities:** Distinguish single-machine, parallel-machine, job-shop scheduling; recognize when scheduling reduces to known classical problems; apply standard heuristics with their guarantees.
- **Anti-capability:** No coverage of stochastic scheduling or online scheduling beyond a brief pointer.
- **Misconception engaged:** "Scheduling is just sorting by priority."
- **Worked example:** CPU scheduling in a real OS or task scheduling in a build system (Bazel, Make). Show why naive greedy fails, where critical-path analysis helps, and how LP relaxation gives provable bounds.
- **Companion-page handoffs:** Scheduling solver comparisons (OR-Tools). Real OS scheduler tracebacks.
- **Cross-references:** LP for scheduling → Vol. 1 Chapter 13. Approximation algorithms → Vol. 1 Chapter 11.

## Chapter 06 — Stable Matching and Gale-Shapley
- **Status:** drafted
- **Length target:** ~2,500 words
- **Source folders:** `Stable_Matching_and_the_Gale-Shapley_Algorithm/` (includes mechanism-design extensions — strategy-proofness covered here).
- **Primary capability:** Recognize when a problem is a stable-matching problem; apply Gale-Shapley correctly; identify which side benefits (proposer-optimal stability).
- **Secondary capabilities:** Extend the model to many-to-one matching (residency match, school choice); recognize when the matching market needs strategy-proofness; diagnose when ties or incomplete preferences break Gale-Shapley.
- **Anti-capability:** No deep treatment of mechanism design impossibility results — sketches only when needed for matching-market reasoning.
- **Misconception engaged:** "Stable matching produces a fair outcome."
- **Worked example:** The medical residency match (NRMP). Show how Gale-Shapley handles real-scale matching, why the algorithm changed in 1998 from program-proposing to applicant-proposing, and what changed for participants.
- **Companion-page handoffs:** Many-to-one matching implementations. School-choice algorithm comparisons. Real NRMP statistics.
- **Cross-references:** Game-theoretic foundations → Chapter 4.

## Chapter 07 — Randomness and Networking
- **Status:** drafted
- **Length target:** ~2,800 words
- **Source folders:** `Randomness_and_Networking/`
- **Primary capability:** Apply randomized algorithms to network problems (random walks, randomized routing, gossip protocols); recognize when network structure makes deterministic methods fail.
- **Secondary capabilities:** Apply expander graphs and rapid mixing arguments; use random walks for sampling; recognize when probabilistic guarantees are sufficient.
- **Anti-capability:** No deep treatment of expander graph constructions.
- **Misconception engaged:** "Random routing is worse than shortest-path routing."
- **Worked example:** Load balancing in a real distributed system (Cassandra-style consistent hashing, or randomized load balancing). Show how randomization beats round-robin under realistic load skew.
- **Companion-page handoffs:** Random walk visualizations. Distributed-systems case studies.
- **Cross-references:** Randomized algorithms foundations → Vol. 1 Chapter 12. Graph foundations → Vol. 1 Chapter 5.

## Chapter 08 — Social Networks
- **Status:** drafted
- **Length target:** ~2,800 words
- **Source folders:** `Social_Networks/`
- **Primary capability:** Apply graph algorithms to social network problems (centrality, community detection, influence maximization); recognize which algorithm fits which question.
- **Secondary capabilities:** Distinguish PageRank-class algorithms; apply modularity-based community detection; understand the limits of network-based prediction.
- **Anti-capability:** No coverage of graph neural networks (magazine territory).
- **Misconception engaged:** "Centrality measures are interchangeable."
- **Worked example:** Influence maximization on a real social-network dataset (e.g., influence-spread modeling for marketing or epidemic-spread modeling for public health). Show why greedy with submodularity guarantees beats simpler heuristics.
- **Companion-page handoffs:** Network analysis libraries (NetworkX, igraph) comparisons. Social-network datasets.
- **Cross-references:** Graph foundations → Vol. 1 Chapter 5. Approximation via submodularity → Vol. 1 Chapter 11.

---

_Generated overview-and-TOC README. Source files (`book.md`, `outline.md`, etc.) remain the working documents._
