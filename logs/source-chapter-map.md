# Source-Chapter Map — Algorithms by Bear, Vol. 2

Built: 2026-04-30. One-time mapping pass. Reverse-index by target chapter.

Source paths are relative to `books/algorithms-by-bear-vol2/source/`. Line numbers are approximate, point to section starts.

8 source folders, 8 target chapters. Not 9 — Ch 9 (Mechanism Design and Auctions) was removed when outline was reconciled to source folders. Auction and mechanism-design content from `Game_Theory/` and `Stable_Matching_and_the_Gale-Shapley_Algorithm/` lives in those chapters (Ch 4 and Ch 6) directly.

---

## Chapter 01 — Bayes' Rule and Bayesian Inference

Primary: `Bayes_Rule/Bayes_Rule.md`

Keep:
- `## Introduction to Bayes's Rule` (3–392) — definitions, historical context, importance, applications overview
- `## Theoretical Foundations` (393–484) — probability theory, the formula, prior/likelihood/posterior/evidence
- `## Bayesian Inference and Reasoning` (485–679) — updating beliefs, examples, Bayesian vs frequentist
- `## Applications of Bayes's Rule → Medical Diagnosis` (756–813) — informs the worked example
- `## Bayesian Computational Methods → MCMC, ABC, Bayesian Networks` (888–1137) — overview
- `## Challenges in Bayesian Analysis → Choosing Priors, Computational Complexity, Interpretation` (1138–1275)
- `## Advanced Topics → Hierarchical Models, Non-parametrics, Decision Theory` (1432–1640) — brief
- `## Case Studies → Spam Filtering, Sports Analytics, Bayesian Optimization` (1276–1431)

Cut:
- `## Bayes's Rule in the Age of Big Data → Future Directions` (1641+)
- `## Bayesian Methods in Deep Learning` (1683+) — magazine
- `## Exercises and Problems` (none in source for this file, but the convention applies)
- `## Further Reading and Resources` — companion page

## Chapter 02 — Optimal Stopping

Primary: `Optimal_Stopping/Optimal_Stopping.md`

Keep:
- `## Introduction to Optimal Stopping` (3–65) — definitions, significance, history
- `## Theoretical Foundations` (66–182) — decision theory, secretary problem, probability
- `## Models and Strategies` (183–360) — classic secretary, marriage problem, real options
- `## Mathematical Framework` (361–474) — martingales, DP, Bellman equations
- `## Optimal Stopping in Finance and Economics` (475–613) — American options, real estate, investment
- `## Computational Methods` (614–716) — Monte Carlo, algorithmic, ML
- `## Practical Applications → Career, Dating, Medical` (843–996)
- `## Challenges and Limitations → Complexity, Ethics, Predictive Accuracy` (997–1145)

Cut:
- `## Advanced Topics → Multi-stage, Bandits, Incomplete Info` (717–842) — Multi-stage and bandits cross-route to Ch 3 (briefly)
- `## Future Directions → AI Integration` (1146–1227) — magazine
- `## Conclusion` (1228+)
- `## Exercises and Problems`
- `## Further Reading and Resources`

## Chapter 03 — Explore vs Exploit (Multi-Armed Bandits)

Primary: `Explore_Exploit/Explore_Exploit.md`

Keep:
- `## Introduction to Explore/Exploit Dilemmas` (3–76)
- `## Theoretical Foundations` (77–227) — balancing exploration/exploitation, statistical decision theory, optimality
- `## Models of Explore/Exploit Decisions` (228–438) — multi-armed bandit, MDPs (brief), RL (cross-ref to magazine)
- `## Strategies` (439–652) — epsilon-greedy, UCB, Thompson sampling
- `## Applications in Machine Learning and AI` (653–915) — dynamic pricing, content recommendation, adaptive routing
- `## Challenges` (916–1021) — regret minimization, uncertain environments, scaling
- `## Case Studies → E-commerce, Clinical Trials, Autonomous Systems` (1022–1271)

Cross-route:
- MDP and full RL content (236–438): brief in Ch 3, full RL deferred to magazine per outline.md preface

Cut:
- `## Future Directions → Deep Learning, Ethics` (1272–1341) — magazine
- `## Conclusion`
- `## Exercises and Problems`

## Chapter 04 — Game Theory

Primary: `Game_Theory/Game_Theory.md`

Keep:
- `## Introduction to Game Theory` (3–115) — definitions, history, applications
- `## Theoretical Foundations` (116–300) — players/strategies/payoffs, cooperative vs non-cooperative, Nash equilibrium
- `## Classical Game Theory Models` (301–470) — Prisoner's Dilemma, Battle of the Sexes, Chicken
- `## Strategic Moves and Dynamics` (471–597) — sequential games, repeated games, bargaining
- `## Information in Games` (598–722) — complete vs incomplete info, signaling, screening, Bayesian games
- **Auction and mechanism content** (629–722, the "Auction Games" case study, "Sealed-bid auction" example, screening as mechanism design): kept here per the reconciled outline. Not routed to a non-existent Ch 9. This is the chapter's expanded coverage area.
- `## Evolutionary Game Theory` (723–842) — brief; ESS, Hawk-Dove
- `## Behavioral Game Theory` (875–989) — limited rationality, altruism, experimental
- `## Network Games` (991–1158) — game theory in social networks (cross-ref to Ch 8)
- `## Applications` (1159–1323) — economic competition, political campaigns

Cut:
- `## Advanced Topics in Game Theory` (1324+) — speculative
- `## Conclusion`
- `## Further Reading and Resources`

## Chapter 05 — Scheduling

Primary: `Scheduling/Scheduling.md`

Keep:
- `## Introduction to Scheduling` (3–74)
- `## Theoretical Foundations` (75–181) — classification, optimality criteria, complexity
- `## Scheduling Algorithms` (182–349) — FCFS, SJF, priority, round-robin
- `## Advanced Scheduling Techniques` (350–509) — preemptive vs non-preemptive, multiprocessor, real-time
- `## Scheduling in Operating Systems` (510–638) — process, thread, I/O scheduling
- `## Scheduling in Production and Manufacturing` (639–751) — job shop, flow shop, project (Make, Bazel inform worked example)
- `## Scheduling in Distributed Systems` (752–912) — load balancing, task allocation, cloud
- `## Scheduling in Networks` (913–1037) — packet scheduling, bandwidth, QoS
- `## Mathematical and Heuristic Methods` (1038–1224) — LP approaches (cross-ref Vol. 1 Ch 13), heuristics
- `## Case Studies → Data Centers, Smart Grids` (1296–1447)

Cut:
- `## Evolutionary Algorithms and ML` (1147–1224) — brief reference, full coverage to magazine
- `## Challenges and Future Directions → Emerging Applications` (1225–1295) — speculative
- `## Conclusion`
- `## Exercises and Problems`

Cross-references heavy — Vol. 1 Ch 11 (approximation) and Ch 13 (LP).

## Chapter 06 — Stable Matching and Gale-Shapley

Primary: `Stable_Matching_and_the_Gale-Shapley_Algorithm/README.md` — **VERY THIN** (31 lines, lesson outlines only)

Material from outline:
- Definition of stable matching
- Gale-Shapley algorithm (proposer-optimal stability)
- Proof of correctness and efficiency
- Variations (many-to-one, ties, incomplete preferences)
- Applications (NRMP, school choice)

This chapter is HIGHEST-RISK for fabrication in this batch — analogous to Vol. 1's NP-Completeness chapter (Ch 10). Composition is from canonical stable-matching knowledge anchored to:
- Gale and Shapley 1962 (Journal of the American Mathematical Monthly) [verify]
- Roth 1984 (matching markets analysis, NRMP) [verify]
- Roth and Peranson 1999 (NRMP redesign) [verify]
- Abdulkadiroğlu and Sönmez 2003 (school choice) [verify]

The strategy-proofness extension content (per outline.md) must compose from canonical knowledge of one-sided strategy-proofness in Gale-Shapley.

## Chapter 07 — Randomness and Networking

Primary: `Randomness_and_Networking/Randomness.md`

Keep:
- `## Introduction to Randomness` (3–68)
- `## Theoretical Foundations` (69–202) — probability theory, LLN/CLT, randomness vs determinism
- `## Generating Randomness` (203–326) — PRNG, TRNG, cryptographic randomness (cross-ref Vol. 1 Ch 12)
- `## Applications of Randomness` (327–469) — randomized algorithms (cross-ref Vol. 1 Ch 12), simulation, decision making
- `## Randomness in Nature and Society → Quantum, Evolution, Economics` (470–572)
- `## Measuring and Testing Randomness` (573–649)
- `## Case Studies → Genetic Algorithms, Network Security` (904–1000)

Cut:
- `## Philosophical and Ethical Considerations` (650–685) — out of scope for reference
- `## Randomness in Art and Creativity` (686–802) — out of scope
- `## Challenges and Future Directions → Predictive Models` (803–903) — speculative
- `## Conclusion`
- `## Exercises and Problems`

**Note:** The "and Networking" half of the chapter title is not strongly represented in the source — the source is mostly about randomness in general. The networking-specific content (random walks for routing, gossip protocols, distributed-systems load balancing) is partly here and partly Claude addition. Cassandra-style consistent hashing and randomized load balancing (per outline.md worked example) require composition from canonical distributed-systems knowledge.

## Chapter 08 — Social Networks

Primary: `Social_Networks/Social_Networks.md`

Keep:
- `## Introduction to Social Networks` (3–86)
- `## Theoretical Foundations` (87–222) — graph theory basics, small world, network models
- `## Knowledge Graphs` (223–290) — brief
- `## Metrics for Analyzing Social Networks` (291–419) — centrality, density, clustering, community detection
- `## Connections in Social Networks` (420–665) — homophily, multiplexity, mutuality
- `## Distributions and Structural Features` (666–812) — bridges, tie strength, distance/paths
- `## Influence and Diffusion in Social Networks` (813–900) — diffusion models, influence-maximization algorithms (worked example anchor)
- `## Modelling and Visualization` (901–1017) — modelling, visualization tools
- `## Advanced Topics → Signed/Weighted, Dynamic, Influence Diffusion` (1018–1130)
- `## Applications` (1131–1198) — marketing, public health, political networks
- `## Case Studies → Twitter/Facebook, Knowledge Graphs, Epidemic Spread` (1267–end)

Cut:
- `## Challenges and Future Directions → Privacy/Ethics, Big Data, ML on Networks` (1199–1266) — used selectively
- `## Conclusion`
- `## Exercises and Problems`

Submodularity for influence maximization (per outline.md worked example) — cross-reference to Vol. 1 Ch 11.

---

## Cross-routing decisions

**Game_Theory ↔ Stable_Matching split:** Original 9-chapter plan had a Ch 9 "Mechanism Design and Auctions" pulling from both folders. With Ch 9 removed, auction-and-mechanism content stays put:
- Game_Theory.md auction case study (line 629) and screening/signaling content stays in Ch 4
- Stable_Matching strategy-proofness extensions (the 31-line README mentions these in passing) stay in Ch 6

## Out-of-scope flags (cut entirely)

- All "Exercises and Problems" sections (every source file)
- All "Conclusion" / "Conclusions" sections
- All "Future Directions" / "Future Trends" speculative sections
- All "Further Reading and Resources" sections (companion page handles)
- Bayesian methods in deep learning → magazine
- Full RL coverage → magazine
- Quantum and ethics-of-AI sections → out of scope
- Philosophical / artistic explorations of randomness → out of scope

## Vol. 1 cross-references (heavy in Vol. 2)

Chapters that cross-reference Vol. 1:
- Ch 1 (Bayes) → Vol. 1 Ch 12 (probability foundations in randomized algorithms)
- Ch 5 (Scheduling) → Vol. 1 Ch 11 (approximation), Vol. 1 Ch 13 (LP)
- Ch 7 (Randomness) → Vol. 1 Ch 12 (randomized algorithms), Vol. 1 Ch 5 (graph foundations)
- Ch 8 (Social Networks) → Vol. 1 Ch 5 (graph foundations), Vol. 1 Ch 11 (submodularity for influence maximization)

All Vol. 1 chapter numbers verified against `books/algorithms-by-bear-vol1/outline.md`.

## Magazine flags

- Bayesian deep learning
- Full RL (referenced from Ch 3)
- Graph neural networks (referenced from Ch 8)
- Generative models (any references)
- Modern dynamic pricing systems (referenced from Ch 4)
