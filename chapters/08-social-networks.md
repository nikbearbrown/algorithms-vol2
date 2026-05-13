# Social Networks

## TL;DR

Social-network analysis applies graph algorithms to data about relationships — friendships, follows, citations, collaborations, retweets, transactions. Reach for this chapter when a problem asks "who matters?" (centrality), "who clusters together?" (community detection), or "if I activate a small set, how far does influence spread?" (influence maximization). After consulting it, you can choose the right centrality measure, distinguish modularity-based community detection variants, and apply greedy influence maximization with submodularity guarantees.

## Recognition pattern

Three signals.

*The data is relationships.* Followers, friends, collaborators, citations, edges in any graph where edges encode connection between entities. The questions you can answer depend on the relationship structure — directed vs undirected, weighted vs binary, signed (positive/negative) or single-sign.

*The question is about position or spread.* "Who is most central?" "Which group does this person belong to?" "If I want to reach a target audience, which seeds maximize spread?" These are network questions; pure individual-level analysis (regression on attributes) misses the network structure.

*The network is large enough that exact computation is constrained.* Social networks have millions to billions of vertices. Algorithms that scale (`O(V + E)` BFS-based, `O(E log V)` priority-queue-based, randomized sampling) earn their place; algorithms that don't scale (all-pairs shortest paths in dense computation) require approximation.

A signal social-network analysis is *not* the right tool: the entities don't actually have meaningful relationships. Treating users as a graph because they share a platform, without modeling actual relationships, produces network-shaped data without network structure. The graph algorithms then reflect noise rather than signal.

The misconception engaged in §8 — "centrality measures are interchangeable" — produces practitioner errors at scale. Different centralities answer different questions; using one when another is appropriate gives a confidently wrong answer.

## What you need to know first

This chapter assumes graph fundamentals (Vol. 1 Chapter 5) — vertices, edges, BFS, DFS, shortest paths. For the matrix-vector view of PageRank and other linear-algebraic centralities, basic linear algebra. For submodularity in influence maximization, see Vol. 1 Chapter 11 (approximation algorithms — the greedy algorithm with submodularity gives `(1 − 1/e)` approximation). For random walks underlying network sampling and personalized PageRank, see Chapter 7.

## Centrality — four canonical measures

Centrality answers "how important is this vertex?" Different measures formalize importance differently.

**Degree centrality.** The simplest: count of edges incident to a vertex. Cheap to compute (`O(1)` per vertex with the right representation). Captures local prominence — many connections — but ignores who those connections are. A vertex with many low-importance neighbors and a vertex with many high-importance neighbors look identical.

Use when: local connectivity is the question. Limit: misses indirect importance.

**Betweenness centrality.** Counts how often a vertex lies on shortest paths between other pairs of vertices. High betweenness = bridge or bottleneck. Computable in `O(V·E)` for unweighted graphs (Brandes 2001) [verify].

Use when: identifying brokers, structural holes, communication choke points. Limit: expensive at scale; sensitive to small graph changes.

**Closeness centrality.** Average inverse shortest-path distance to all other vertices. High closeness = quickly reaches everyone. Computable in `O(V·E)` for unweighted graphs.

Use when: information-spread or reachability questions. Limit: requires a connected graph; disconnected components break the measure.

**Eigenvector centrality (and PageRank).** A vertex's centrality is proportional to the sum of its neighbors' centralities. Recursive — high-importance neighbors confer importance. Computed by power iteration on the adjacency matrix (or the transition matrix with damping for PageRank).

PageRank (Brin and Page 1998) [verify] adds a teleportation factor: with probability `(1−d)`, the random walker jumps to a uniformly random vertex. This solves dangling-vertex pathologies and ensures the stationary distribution exists for all graphs.

Use when: importance propagates through links (web ranking, citation, expertise). Limit: dominated by hubs in scale-free networks.

## Community detection

Most real networks have community structure: subsets of vertices densely connected to each other and sparsely connected outside. Community detection identifies these subsets.

**Modularity.** A scoring function for a partition: `Q = (1/2m) Σ [A_{ij} − k_i k_j / 2m] · 1_{c_i = c_j}` where `A` is the adjacency matrix, `k_i` is degree, and the indicator is 1 when `i` and `j` are in the same community. High modularity = more within-community edges than expected at random. Newman 2004 [verify].

**Louvain method.** Greedy modularity optimization. Each vertex starts in its own community; iteratively move vertices to neighboring communities that maximize modularity gain; aggregate communities into super-vertices and repeat. Time: `O(N log N)` typically, scales to billions of vertices. Blondel et al. 2008 [verify]. The dominant production choice.

**Leiden algorithm.** Refinement of Louvain that addresses a known issue with Louvain producing badly-connected communities. Traag et al. 2019 [verify].

**Spectral clustering.** Eigenvectors of the graph Laplacian give clustering directions. The number of near-zero eigenvalues approximates the number of communities; the eigenvectors give partition information. Computationally expensive; works well on small to medium networks.

**Stochastic block models.** Probabilistic generative model where each vertex has a latent community label; edges form with probabilities that depend on community labels. Inference via MCMC or variational methods. Used when community detection benefits from statistical foundations and goodness-of-fit testing.

**Resolution limit.** Modularity-based methods cannot detect communities below a size threshold determined by the network's total size — the "resolution limit" (Fortunato and Barthélemy 2007) [verify]. For very small communities in very large networks, modularity merges them. Newer methods (CPM, multi-resolution Louvain) address this.

## Influence and diffusion

How does influence spread through a network? The classical models.

**Independent Cascade (IC) model.** Each vertex is initially active or inactive. Active vertex `u` has one chance to activate its neighbor `v` with probability `p_{uv}`. Activations propagate in discrete time steps until no new activations occur.

**Linear Threshold (LT) model.** Each vertex has a random threshold `θ_v` and edge weights `w_{uv}` that sum to at most 1. Vertex `v` becomes active when the sum of weights from active neighbors exceeds `θ_v`.

Both models are widely used; choice depends on the dynamics being modeled. IC fits viral propagation (each contact is a separate chance). LT fits behavioral adoption (cumulative pressure from neighbors).

**Influence maximization problem.** Given a graph and a budget `k`, choose `k` "seed" vertices to activate initially that maximize the expected number of vertices activated by the diffusion. NP-hard in both IC and LT.

**Greedy with submodularity.** The expected influence spread under IC and LT is *submodular* in the seed set (adding a seed to a smaller set helps more than adding it to a larger set). Greedy — at each step, add the seed maximizing marginal influence — is a `(1 − 1/e) ≈ 0.632`-approximation by the Nemhauser-Wolsey-Fisher 1978 [verify] result on submodular maximization. Kempe-Kleinberg-Tardos 2003 [verify] established this for influence maximization specifically.

The submodularity argument is the chapter's most consequential fact for practitioners. It says: greedy is provably good (within a factor of `1/e ≈ 0.37` of optimal), no matter the graph, no matter the seed budget. The same is not true of degree heuristics or other centrality-based selections, which can be arbitrarily bad in adversarial cases.

**Computational cost.** Each greedy iteration requires estimating influence spread, which is `#P-hard` to compute exactly. Monte Carlo simulation is the workhorse — repeatedly simulate diffusion from candidate seed sets, average over runs. CELF (Cost-Effective Lazy Forward, Leskovec et al. 2007) [verify] reduces simulation cost by lazy evaluation of marginal gains.

## Decision rules

| Question | Approach |
| --- | --- |
| Most-connected vertices | Degree centrality |
| Bridges and structural holes | Betweenness centrality |
| Vertices that reach everyone fast | Closeness centrality |
| Web-ranking style importance | PageRank or eigenvector centrality |
| Find dense subgraphs | Modularity-based community detection (Louvain or Leiden) |
| Probabilistic community assignments | Stochastic block model |
| Maximum spread on small budget | Greedy influence maximization with submodularity |
| Practical influence maximization, large network | CELF + Monte Carlo simulation |
| Local neighborhood structure | Clustering coefficient |
| Distance distribution | All-pairs shortest paths (small networks) or sampling (large) |
| Detect rare/structural roles | Network embedding (DeepWalk, node2vec) + clustering |
| Predict missing edges | Link prediction with node similarity scores |
| Network too large for direct computation | Sampling, approximation, or graph neural networks (magazine) |

## Worked example — influence maximization for marketing

A company wants to launch a new product. They have a social-graph dataset of 100 million users [verify] with follow relationships from a major platform. Budget: free product samples to 1,000 users. Goal: maximize the number of users who eventually adopt the product through cascading influence.

This is influence maximization with budget `k = 1000`. The target metric is *expected number of activated users* under a diffusion model (IC or LT).

**Naive degree heuristic.** Pick the 1,000 highest-degree users. Send them samples. Worst-case: the 1,000 highest-degree users are mostly in the same community, redundantly reaching the same downstream audience. Empirical studies show degree heuristics produce influence spread that's roughly half what greedy achieves on real networks [verify].

**Greedy with submodularity.** At step `i`, pick the user `u` whose addition to the current seed set maximally increases expected influence. Continue until 1,000 users selected.

The submodularity guarantee: the resulting seed set produces influence within `(1 − 1/e) ≈ 0.632` of the optimal `k = 1000` set. The bound is *worst-case*; on real networks the achieved fraction is typically higher (often 0.9 of optimal).

**Implementation challenges.**

*Influence spread is expensive to compute.* Each marginal-gain evaluation requires running many Monte Carlo simulations of diffusion from the candidate seed set. For 100M users and 1000 candidate seeds per round, naive greedy is prohibitively expensive.

*CELF for efficiency.* Cost-Effective Lazy Forward exploits submodularity to skip re-evaluating marginal gains that cannot exceed the current best. Reduces simulation cost by 10–100× without changing the guarantee.

*Distributed computation.* The 100M-vertex graph doesn't fit on one machine. Distributed graph processing (Pregel, GraphX, Giraph) and approximate algorithms (sketch-based influence estimation) handle the scale.

**Why centrality-based approaches fail.**

A practitioner might argue: "Just use the highest-PageRank users." PageRank captures importance via random walks; it doesn't capture diffusion-spread. High-PageRank users may have audiences that overlap with each other; diffusion from them may be redundant.

Greedy with submodularity *adapts* — after picking the first seed, the marginal gain of subsequent candidates is computed conditional on the first seed. The algorithm picks complementary seeds (different downstream reach) rather than redundant ones. Centrality measures don't have this adaptivity.

**Epidemiological applications.** The same algorithm with the same submodularity argument applies to disease spread modeling. Public health agencies can identify vaccination targets that maximize herd-immunity coverage. The IC/LT models map onto SIR/SIS epidemic models with appropriate parameter translation. Used in real public-health practice with case-study work in measles control, HIV prevention, and (post-2020) COVID-19 contact tracing strategies [verify].

**The lesson.** Influence maximization is the canonical example of greedy with submodularity — a polynomial-time approximation with a provable bound on a hard problem. The bound is loose on most real networks; the empirical performance is excellent. Centrality heuristics are easier to compute but produce arbitrarily worse results in adversarial cases and meaningfully worse results in typical cases.

## Failure modes — when "centrality measures are interchangeable" misleads

The misconception engaged: "Centrality measures are interchangeable."

Different centralities answer different questions. Conflating them produces wrong answers.

**Degree centrality vs eigenvector centrality.** A vertex with 1000 neighbors of low importance has high degree centrality. A vertex with 10 neighbors of high importance has high eigenvector centrality. PageRank and degree disagree on hubs versus authorities — Brin and Page's distinction was deliberate.

**Closeness centrality requires a connected graph.** On a disconnected graph, closeness is undefined for vertices that can't reach all others. Replacing infinity with a large constant produces misleading rankings. Use harmonic centrality or component-aware variants.

**Betweenness centrality is fragile.** Removing a single edge can dramatically change betweenness rankings. Insensitive to edge weights unless explicitly weighted. Computationally expensive at scale; approximation algorithms have their own biases.

**PageRank dominated by hubs.** In scale-free networks, PageRank concentrates on the hub and a small number of others. The non-hub structure is hard to extract. Personalized PageRank (with non-uniform teleportation) gives finer-grained importance.

**Centrality is not influence.** Influence is a process question (how does information spread?), not a structural question. The most central vertex by any structural measure may not be the best seed for influence spread, especially under specific diffusion models.

**Real networks have multiple "centers."** Hubs, brokers, peripherals, and bridges are distinct roles. A single centrality measure flattens this multidimensional structure into one number. Use multiple centralities, or use embedding-based methods that capture role rather than rank.

**Small changes in graph definition produce large changes in centrality.** Whether to include a "weak" relationship as an edge, whether to weight by recency, whether to include retweets vs follows — these choices have large effects on rankings. Centrality is a function of the graph, and the graph's construction is itself a modeling choice.

**Centrality misses temporal structure.** Static centrality measures average over time. Dynamic networks have time-varying centralities; a vertex active recently may be more important now than one with high historical centrality. Temporal-network methods (Holme-Saramäki 2012) [verify] address this.

The corrective heuristic: state the centrality question precisely (most connected? most central in shortest-path sense? most influential in random-walk sense? most influential under specific diffusion model?), then choose the matching measure.

## Cross-references

For graph fundamentals (BFS, DFS, shortest paths) underlying centrality computation, see Vol. 1 Chapter 5. For PageRank as a random walk and the underlying random-walk theory, see Chapter 7. For submodularity and greedy approximation guarantees on NP-hard problems, see Vol. 1 Chapter 11. For the NP-hardness of influence maximization specifically, see Vol. 1 Chapter 10. For network flow as bipartite matching (the matching-market analog), see Vol. 1 Chapter 9. For randomized algorithms underlying Monte Carlo influence estimation, see Vol. 1 Chapter 12.

## Companion-page handoffs

Network analysis libraries (NetworkX, igraph, graph-tool) comparison; social-network datasets (SNAP, KONECT, Network Repository) catalog; Louvain and Leiden implementations; PageRank deep-dive; influence-maximization benchmarks across IC, LT, and SIR diffusion models; CELF implementation; pointer to magazine for graph neural networks. Available at bearbrown.co/algorithms-by-bear-vol2/chapter-8.

## What this chapter does not enable

This chapter does not give a treatment of graph neural networks (GNNs) — graph convolutional networks, message-passing neural networks, graph attention networks. GNN coverage lives in the *Algorithms by Bear* magazine. The chapter also does not cover signed networks (with positive and negative edges) or temporal networks (with edge timestamps) at depth; both are covered briefly. Spectral graph theory at the level required for advanced community detection (matrix functions on the Laplacian, Cheeger's inequality, expander mixing) lives in spectral graph theory texts.

## Capability statement

You can now apply graph algorithms to social-network problems — centrality, community detection, influence maximization; recognize which algorithm fits which question; distinguish PageRank-class importance measures from local-degree measures; apply modularity-based community detection at scale; use greedy with submodularity for influence maximization with provable approximation; and avoid the failure mode of treating centrality measures as interchangeable when they answer different questions. The next time a network-analytic question arrives — who matters? who clusters together? who maximizes reach? — the path from question to algorithm to deployment is in your hands.


---

## LLM Exercise — Chapter 8: A Network Decision and the Diary Synthesis

**Project:** *Decision Diary*.

**What you're building this chapter:** Two artifacts. (a) One final diary entry on a network-position or influence decision. (b) A *synthesis* pass that reads across all eight entries to surface the patterns in your decision-making the diary has made visible.

**Tool:** Claude Project (your *Decision Diary* — by now, the accumulated context is the project's real asset).

**The prompt** (send as a single message; the project will produce both artifacts):

```
Chapter 8 entry — Social Networks. Plus the diary synthesis.

PART ONE — Final entry.

The decision I'm thinking through: [one or two sentences naming a
real network-position or influence decision. Examples: who to recruit
into a community of practice so the idea spreads; whose endorsement
matters most for a launch (which centrality?); how to identify
under-leveraged people in my org's collaboration network; how to
design influence-spread for a marketing campaign; how to think about
who I personally should be closer to in my professional network for
career leverage; how to read a citation graph for research direction.]

Help me work through this as a social-network problem. The chapter's
named misconception is "centrality measures are interchangeable" —
they aren't, and using the wrong one gives a confidently wrong
answer.

Walk me through:

1. **What's the network?** Vertices, edges, directed or undirected,
   weighted or binary. If I'm describing a network without being
   able to name the edges, I'm not yet in network territory.

2. **What's the actual question?**
   - "Who's most central?" (centrality — but which kind?)
   - "Who clusters together?" (community detection)
   - "If I activate a small set, how far does influence spread?"
     (influence maximization)
   - Something else?

3. **Pick the right centrality.**
   - Degree: most connections.
   - Betweenness: lies on most shortest paths between others
     (broker, bottleneck).
   - Closeness: short average distance to all others.
   - Eigenvector / PageRank: connected to important others.
   - Each answers a different question. Which question am I
     asking?

4. **If it's influence maximization:** the chapter notes that
   greedy with submodularity gives a (1 − 1/e) guarantee.
   What's the diffusion model — linear-threshold, independent-
   cascade? What's the seed-set budget?

5. **What are the limits of network-based prediction here?**
   The chapter is explicit that not everything network-shaped is
   network-structured — sometimes the relationships I'm treating
   as edges are noise.

PART TWO — Synthesis across the diary.

Now look across all eight entries (you have them in your project
context). Surface:

1. **Recurring failure modes in my decision-making.** Where do I
   consistently underweight priors? Where do I over-explore or
   under-explore? Where do I model opponents as more rational
   than they are? Where do I treat non-stationary situations as
   if they were stationary?

2. **The methods I reach for naturally vs. the ones I avoid.**
   Patterns. Some readers are Bayesian by instinct and
   under-use game-theoretic framings; some are the reverse.

3. **The outcomes I should chase down.** Each entry had a
   "*What would change my mind*" commitment. Which of those
   outcomes can be observed in the next 1, 3, 6 months? Make me
   a list with check-in dates.

4. **One sentence that captures what the diary has taught me
   about how I decide.** Not flattering. Honest.

Output: two markdown sections. The first is the standard diary
entry (same heading template as previous chapters). The second is
a "Diary synthesis — [date]" section with the four numbered
findings above and a one-sentence honest summary at the end.
```

**What this produces:** Two artifacts. (a) A final diary entry on a network decision. (b) The synthesis — the most valuable artifact in the whole project, because it tells you the patterns your decision-making has been showing you for eight chapters but you weren't yet able to see.

**How to adapt this prompt:**

- *For your own project:* The system prompt personalizes it. The synthesis pass is the unique value of having used a project across all eight entries.
- *For ChatGPT / Gemini:* Both work. If you used Custom GPT / Gem with accumulated chat history, the synthesis is the moment that justifies the persistent-context setup.
- *For Claude Code:* Not the right fit, though after the synthesis you might Claude-Code-it into a published portfolio piece — eight chapters of decision analysis is portfolio-grade if you want to make it public.
- *For a Claude Project:* This is the chapter that justifies the entire project structure. The accumulated context across all eight entries is what makes the synthesis possible.

**Connection to previous chapters:** All of them. The synthesis is the chapter — it reads back across the seven prior entries.

**Preview of next chapter:** None — this is the volume's final chapter and the diary's closing entry. Set six-month and one-year calendar reminders to revisit each entry and fill in the "Outcome" section. The diary becomes most valuable in retrospect, when the predictions you made meet the realities they were predictions about.

---

## 🕰️ AI Wayback Machine

The ideas in this chapter didn't appear from nowhere. **Mark Granovetter** published "The Strength of Weak Ties" in 1973 — arguing that the loose acquaintances you barely know matter more for job-finding and information flow than your closest friends. It became one of the most-cited papers in the history of sociology.

**Run this:**

```
Who is Mark Granovetter, and how does his 1973 paper on the strength of weak ties connect to the social network analysis we covered in this chapter? Keep it to three paragraphs. End with the single most surprising thing about his career or ideas.
```

→ Search **"Mark Granovetter"** on Wikipedia. See what the model got right, got wrong, or left out.

**Now make the prompt better.** Try one of these:

- Ask it to explain Granovetter's "forbidden triad" in plain language and connect it to the clustering coefficient measurements you ran.
- Add a constraint: "Answer as the abstract of a follow-up paper to 'The Strength of Weak Ties,' written fifty years later."

What changes? What gets better? What gets worse?
