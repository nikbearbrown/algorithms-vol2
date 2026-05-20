# Chapter 8 — Social Networks

*The most important person in any network is almost never who you think.*

---

Here is a fact that bothered me the first time I heard it.

In 1973, a sociologist named Mark Granovetter published a paper arguing that the people who matter most for spreading information through a social network are not your close friends. They are your *weak ties* — the acquaintances you barely know, the former colleagues you see twice a year, the distant contacts you almost never think about. Your close friends, it turns out, mostly know the same things you know. Your weak ties know things from entirely different parts of the network. If you want information to travel far, you route it through the people you barely talk to.

This is counterintuitive in a specific way. It is not just surprising — it is wrong in the direction you'd expect. Strong relationships feel like they should be strong carriers. Weak relationships feel fragile, unreliable. But the network's information structure doesn't care about the strength of your affection. It cares about whether an edge bridges two otherwise disconnected regions. Weak ties are often bridges. Strong ties are often redundant.

Understanding why that's true — and what it implies for the algorithms we use to analyze networks — is what this chapter is about.

<!-- → [DIAGRAM: small graph with two dense clusters (strong ties within each cluster shown as thick edges) connected by a single thin edge (weak tie) — label one cluster "your close friends" and the other "a different community"; annotate that information starting in cluster 1 can only reach cluster 2 by crossing the weak-tie bridge; student should see visually why weak ties are structurally irreplaceable even when they feel unimportant] -->

---

## What you're looking at

A social network is a graph. Vertices are entities — people, accounts, organizations, papers, web pages. Edges are relationships — friendships, follows, citations, collaborations, transactions, retweets. The graph might be directed (A follows B, but B doesn't follow A) or undirected (A and B are friends, symmetrically). Edges might be weighted (how many emails did they exchange?) or binary (did they interact at all?).

Everything that follows is graph mathematics applied to this structure. But the graph mathematics earns its place only because the graph actually represents something real. If you take a platform's user list and draw edges between users who share the same city, you get a graph-shaped object. What you don't get is a social network — those edges don't encode actual relationships, so the algorithms produce graph-shaped noise rather than social-network insight.

The first discipline of network analysis is the one most often skipped: make sure your edges mean something.

Three kinds of questions come up repeatedly.

*Who matters?* This is centrality. Not "who has the most followers" — that's one answer to one version of the question. Different formulations of "who matters" produce different answers, and conflating them is the canonical error.

*Who clusters together?* This is community detection. Real networks have dense subgraphs — regions where many vertices connect to each other and few connect outside. Identifying those regions reveals the community structure of the network.

*If I activate a small number of vertices, how many can I eventually reach?* This is influence maximization. It is the formalization of "who should I seed a marketing campaign to," "which people should I vaccinate to maximize herd immunity," "who should I recruit if I want an idea to spread."

These three questions are distinct. The algorithms that answer them are different. The failure modes are different. Start by knowing which question you're actually asking.

---

## Centrality: four different answers to "who matters"

The simplest measure is degree centrality: count how many edges a vertex has. High degree means many connections. This is cheap to compute and easy to interpret, and it is often wrong as a proxy for importance.

Here is why. Suppose you are a moderately well-connected person who happens to know five extremely well-connected people. Your degree is five. Your neighbor's degree might also be five — five connections to five unknown people who know nobody. Degree centrality treats these the same. But your five connections open doors that your neighbor's five connections do not.

The fix is eigenvector centrality: a vertex's importance is proportional to the sum of its neighbors' importances. This is recursive — you can't compute it in one pass — but it converges via an iterative method called power iteration. Start with any initial importance vector; repeatedly multiply by the adjacency matrix; normalize; repeat until it stabilizes. The stable vector is the leading eigenvector of the adjacency matrix, and it encodes the recursive notion of importance.

PageRank is eigenvector centrality with a repair. The problem with pure eigenvector centrality on directed graphs is pathological: vertices with no outgoing edges become "importance sinks" that absorb centrality and don't distribute it. Brin and Page fixed this with a teleportation factor. With probability $1 - d$ at each step, a random walker jumps to a uniformly random vertex rather than following an edge. This ensures the stationary distribution of the walk exists and is well-defined for any graph. The resulting PageRank scores are the stationary distribution of this modified random walk. For most reasonable choices of $d$ (typically $d = 0.85$), PageRank correlates well with what human judges call "important" on the web.

The third major centrality measure is betweenness. Betweenness centrality counts how often a vertex lies on the shortest path between two other vertices — across all pairs of vertices in the network. A vertex with high betweenness is a bridge. Information flowing between two communities that are only loosely connected must pass through it. Remove it, and the network may fragment. Betweenness is the algorithmic formalization of Granovetter's intuition: the bridges between communities are structurally important regardless of their local degree.

Betweenness is expensive. For an unweighted graph with $V$ vertices and $E$ edges, computing it exactly takes $O(V \cdot E)$ — manageable for networks with millions of vertices, but tight. Approximation algorithms sample pairs and estimate.

The fourth is closeness centrality: the average inverse shortest-path distance from a vertex to all others. High closeness means you can reach everyone quickly. It answers a different question than betweenness — not "do you lie on many paths?" but "if you start from here, how long until you reach everywhere?"

These four measures can disagree completely on the same network. A highly-connected hub has high degree and often high eigenvector centrality, but may have moderate betweenness if its connections are concentrated in one community. A low-degree vertex that bridges two communities can have high betweenness and moderate closeness, but low degree and low eigenvector centrality. The error is choosing one measure and treating it as "the" answer to "who matters." Each measure answers a specific question. Know which question you're asking.

<!-- → [DIAGRAM: one small network (~10 vertices) with two dense clusters connected by a bridge vertex — annotate four separate rankings on the same graph: (1) vertex with highest degree circled in one color, (2) highest betweenness in another (the bridge), (3) highest closeness in a third, (4) highest PageRank in a fourth; the four circles should land on different vertices, making the disagreement visible in one image] -->

---

## Community detection: what clustering means for graphs

Most real networks have community structure. There are regions of high internal density — vertices that connect heavily to each other — separated by sparse connections to the rest of the network. In a friendship network, these are social groups. In a citation network, research subfields. In a corporate email network, teams and departments.

Community detection asks: given the graph's edge structure, infer the community assignments.

The standard quality measure is modularity, defined as the fraction of edges that fall within communities minus the fraction expected if edges were placed at random (holding degree fixed). High modularity means the community structure is better than chance. A partition with modularity near zero has community structure no better than random; near one is perfectly structured (though values above 0.3 to 0.7 in practice already indicate meaningful structure).

$$Q = \frac{1}{2m} \sum_{i,j} \left[ A_{ij} - \frac{k_i k_j}{2m} \right] \cdot \mathbf{1}_{c_i = c_j}$$

where $A$ is the adjacency matrix, $k_i$ is the degree of vertex $i$, $m$ is the total number of edges, and the indicator is 1 when vertices $i$ and $j$ are in the same community. The term $k_i k_j / 2m$ is the expected number of edges between $i$ and $j$ in a random graph with the same degree sequence. Modularity measures excess over this expectation.

Maximizing modularity exactly is NP-hard. The dominant practical algorithm is Louvain: start with every vertex in its own community; greedily move each vertex to the neighboring community that most increases modularity; aggregate communities into super-vertices and repeat until no improvement is possible. Louvain is fast — $O(N \log N)$ in practice — and scales to networks with billions of vertices.

Louvain has a known flaw: it can produce communities that are internally disconnected — two disconnected subgraphs that get merged because merging them increases the global modularity score. The Leiden algorithm (2019) fixes this by adding a refinement step that checks internal connectivity. For most production use, Leiden is the current recommendation.

There is also a deeper issue with modularity-based methods. Modularity has a resolution limit: for large networks, communities below a certain size cannot be detected — they get merged into larger communities regardless of their internal structure. The threshold scales with network size. For very small communities in very large networks, modularity-based methods fail systematically. This is not a bug in the implementation; it is a property of the objective function.

The alternative is the stochastic block model: a probabilistic generative model where vertices have latent community labels, and edges form with probabilities that depend on the community labels of their endpoints. Fitting the model to data via MCMC or variational inference gives both community assignments and a statistical measure of fit. Block models avoid the resolution limit, handle overlapping communities, and come with principled uncertainty quantification. They are slower than Louvain at scale but give more reliable results when small communities matter.

<!-- → [DIAGRAM: side-by-side illustration of Louvain vs. Leiden on a network with one small tight community inside a larger loosely-connected region — left panel shows Louvain merging the small community into the large one (resolution limit failure); right panel shows Leiden correctly identifying the small community as separate; caption should name the resolution limit explicitly] -->

---

## Influence maximization: the greedy guarantee

The influence maximization problem is this. You have a graph and a budget of $k$ vertices to "seed" — activate initially. Under a diffusion model, activation spreads through the network. You want to choose the $k$ seeds that maximize the expected number of eventually-activated vertices.

The two standard diffusion models are Independent Cascade and Linear Threshold.

In Independent Cascade, each active vertex $u$ gets one chance to activate each of its inactive neighbors: with probability $p_{uv}$, it succeeds. Activation propagates in discrete rounds until no new activations occur. Think of viral transmission: each infected person has independent chances to infect their contacts.

In Linear Threshold, each vertex $v$ has a threshold $\theta_v$ drawn uniformly from $[0, 1]$. Each edge $(u, v)$ has a weight $w_{uv}$. Vertex $v$ activates when the sum of weights from already-active neighbors exceeds $\theta_v$. Think of behavioral adoption: you adopt a new behavior when enough of your friends already have.

Influence maximization is NP-hard under both models. No polynomial-time algorithm finds the optimal seed set in general.

But here is the key structural fact that saves us: under both IC and LT, the expected influence spread is a *submodular* function of the seed set. Submodularity means that adding a seed to a smaller set helps at least as much as adding it to a larger set. Formally: for any seed sets $S \subseteq T$ and any vertex $v \notin T$:

$$f(S \cup \{v\}) - f(S) \geq f(T \cup \{v\}) - f(T)$$

This is the diminishing-returns property. Adding a new seed to a small set reaches new people it wouldn't have reached otherwise. Adding the same seed to a large set reaches fewer additional people, because many of them are already covered.

Submodularity is powerful because of a theorem by Nemhauser, Wolsey, and Fisher (1978): for any monotone submodular function, the greedy algorithm — at each step, add the element that maximizes marginal gain — achieves at least a $(1 - 1/e) \approx 0.632$ fraction of the optimal value. This bound holds for all instances, all graphs, all budget values. The greedy algorithm for influence maximization is therefore provably within 37% of optimal, regardless of network structure.

Kempe, Kleinberg, and Tardos proved in 2003 that the IC and LT spread functions are indeed submodular, establishing the guarantee for influence maximization specifically. The result is one of the more consequential algorithmic facts for practitioners: you get a provable approximation bound on a hard problem, and the bound is tight (submodularity is exactly the property that makes the greedy guarantee work, and no stronger guarantee is achievable without assuming more structure).

<!-- → [CHART: bar chart comparing influence spread achieved by three strategies — degree heuristic, PageRank heuristic, and greedy with submodularity — across seed-set budgets k = 10, 50, 100, 500; a horizontal line at (1 − 1/e) × optimal marks the greedy floor; student should see that greedy consistently meets or exceeds its guarantee while centrality heuristics trail significantly at larger budgets] -->

Computing marginal gains requires estimating influence spread from a candidate seed set — a $\#P$-hard computation exactly. Monte Carlo simulation is the standard: simulate the diffusion many times from the candidate set, average the results. For large networks with large budgets, this is expensive. The CELF algorithm (Leskovec et al., 2007) uses submodularity to reduce work: once a candidate's marginal gain falls below the current best, it cannot possibly be the best in this round. Lazy evaluation skips the expensive simulation for most candidates, reducing cost by orders of magnitude without affecting the output.

The comparison to centrality-based heuristics is instructive. The natural shortcut is to seed the highest-degree or highest-PageRank vertices. This sometimes works well. It sometimes doesn't, and there are adversarial constructions where centrality heuristics produce influence spread that is a constant fraction of optimal — arbitrarily bad. Greedy with submodularity has no such adversarial case. The $(1 - 1/e)$ bound holds unconditionally.

---

## A marketing campaign

Let me make the comparison concrete.

A company wants to launch a product on a platform with 100 million users. They can give free samples to 1,000 users and want to maximize the number who eventually adopt through cascading influence. Classic influence maximization with $k = 1000$.

The naive approach: pick the 1,000 highest-degree users. Send them samples. The problem is redundancy. The highest-degree users are often highly connected to each other — they form the core of the network. Their downstream audiences overlap substantially. You might be reaching the same million users 50 different ways while ignoring 90 million users in peripheral communities.

Greedy with submodularity adapts. After picking the first seed, the marginal gain for the second seed is computed conditional on the first being active. Vertices whose downstream audience overlaps heavily with the first seed provide lower marginal gain than vertices in different network regions. The algorithm naturally selects seeds that are complementary — spreading across different communities rather than concentrating in one.

Empirical studies on real social networks show degree heuristics producing influence roughly half what greedy achieves on the same graph and budget. The $(1 - 1/e)$ bound is the floor; the typical performance is considerably better.

The same algorithm applies to vaccination targeting: given a contact network and a limited vaccine supply, maximize herd-immunity coverage. The IC model maps cleanly to SIR epidemic dynamics. Public health applications have used these methods for measles control, HIV prevention, and contact-tracing prioritization. The mathematics is identical; the edge weights encode transmission probabilities rather than social influence. The greedy guarantee holds for the same reason.

<!-- → [INFOGRAPHIC: two-panel network diagram illustrating degree-heuristic seeding vs. greedy seeding on the same 20-vertex network — left panel shows 5 seeds clustered in the high-degree core (seed coverage circles overlapping heavily); right panel shows 5 greedy seeds distributed across different communities (coverage circles touching but not overlapping much); annotate total reachable vertices for each — student should see why complementary seeds outperform redundant seeds] -->

---

## The failure modes

The central mistake this chapter names is "centrality measures are interchangeable." The concrete ways this goes wrong:

Degree centrality misses recursive importance. A low-degree vertex connected to the hub of every major community has high eigenvector centrality and may be the most important vertex in the network for information flow. Degree would rank them unremarkably.

Betweenness centrality is fragile. Adding or removing a single edge can dramatically shift betweenness rankings. It is also computationally expensive and sensitive to the graph's definition — whether to include low-weight edges, whether to handle directed vs. undirected structure. Rankings shift with modeling choices.

Closeness centrality breaks on disconnected graphs. For a vertex that cannot reach all others, closeness is undefined unless you make a convention about how to handle infinity. The harmonic mean (sum of inverse distances, skipping unreachable vertices) is the standard fix, but the resulting rankings differ from the connected-graph definition.

PageRank concentrates in scale-free networks. High-degree hubs absorb PageRank; the non-hub structure is compressed into a small dynamic range. Personalized PageRank — where the teleportation distribution is non-uniform, biased toward a specific set of vertices — gives more discriminative importance scores for vertices in a particular region of the network.

And most importantly: centrality is not influence. Centrality measures static structural properties of the graph. Influence is a dynamic process question — how far does activation spread from this vertex, through this diffusion model, in this particular instance? A high-betweenness vertex that bridges two communities is structurally important, but if the diffusion probabilities on its bridge edges are low, it may carry little actual influence. The algorithms for influence maximization (greedy with submodularity) are designed for the dynamic question; centrality measures are designed for the structural one. Using a structural measure to answer a dynamic question gives a structurally-motivated but process-uninformed answer.

The corrective practice: state the question precisely. Most connected? — degree. Most influential in random-walk terms? — PageRank. Best broker or bottleneck? — betweenness. Fastest to reach everyone? — closeness. Maximum expected spread under IC or LT? — greedy influence maximization. Each of these is a different question. Each has a different answer.

---

## A decision table

| Question | Measure or algorithm |
|---|---|
| Most directly connected | Degree centrality |
| Structural broker or bottleneck | Betweenness centrality |
| Reaches everyone fastest | Closeness centrality |
| Connected to important others | Eigenvector centrality or PageRank |
| Find dense communities at scale | Louvain or Leiden (modularity) |
| Small communities in large network | Leiden, CPM, or stochastic block model |
| Probabilistic community assignments | Stochastic block model |
| Maximize spread from $k$ seeds | Greedy with submodularity + Monte Carlo |
| Large network, maximize spread cheaply | CELF + Monte Carlo |
| Missing-edge prediction | Node similarity scores or embedding |
| Network too large for direct computation | Sampling, approximation, graph neural networks |

---

## What you can now do

You can ask the right question about a social network — centrality, community, or influence — and choose the algorithm that answers it. You know that degree, betweenness, closeness, and PageRank are four different answers to four different formulations of "who matters," and that using one when another is appropriate gives a confidently wrong result.

You know what modularity measures and why it has a resolution limit. You know the difference between Louvain (fast, sometimes disconnected communities) and Leiden (slightly slower, internally connected). You know the stochastic block model as an alternative when small communities or statistical guarantees matter.

You know the influence maximization problem, why it's NP-hard, and why greedy with submodularity achieves $(1 - 1/e) \approx 0.632$ of optimal regardless of graph structure. You know that CELF reduces the computational cost without changing the guarantee. And you know why centrality heuristics fail for influence maximization in adversarial cases — because they answer the structural question rather than the dynamic one.

Granovetter's weak ties are bridges. The algorithms in this chapter find the bridges, measure their structural importance, identify the communities on either side, and compute how far a signal launched from one bridge vertex will travel. That is what graph mathematics gives you that intuition doesn't.

---

## Exercises

### Warm-up

**1.** Consider a small network: vertex A is connected to vertices B, C, D, and E. Vertex B is connected to A and to vertices F, G, and H. Vertex C is connected only to A. Vertices D and E are connected only to A. Vertices F, G, H are connected only to B.

Compute (a) the degree centrality of A and B; (b) which vertex — A or B — has higher eigenvector centrality, and why, without formal calculation; (c) which vertex is the better broker between the F-G-H cluster and the rest of the network.

*Tests: degree vs. eigenvector centrality on a concrete example; intuition for betweenness without computation.*

**2.** Explain in plain language why PageRank adds a teleportation factor, and what specific pathology it fixes. Give a concrete example of a graph structure (you can describe it in words) where pure eigenvector centrality would produce a meaningless result, and show why teleportation fixes it.

*Tests: the PageRank teleportation repair as a solution to a specific structural problem, not a magic constant.*

**3.** A colleague says: "I ran betweenness centrality on our company's email network and found the top five brokers. Then I added one new person to the network. Now the top five brokers are completely different. Betweenness must be broken." Respond to this critique. Is the colleague right that betweenness is "broken," or is this expected behavior? What does it tell you about how to use betweenness in practice?

*Tests: fragility of betweenness centrality; appropriate expectations for structural measures on changing graphs.*

---

### Application

**4.** A research team wants to identify which scientists in a citation network are "most important." They are considering three approaches: (a) count how many papers cite each scientist (in-degree); (b) compute PageRank on the citation graph; (c) compute betweenness on the citation graph.

For each approach, name the specific question it answers and describe a scenario where it gives the right answer — and a scenario where it gives a misleading one. Which approach would you recommend for a team trying to identify "whose ideas have influenced the most subsequent work," and why?

*Tests: matching centrality measure to research question; understanding when each measure fits and when it misleads.*

**5.** You run Louvain community detection on a large professional network (50,000 users) and find 200 communities. A colleague points out that the company's internal org chart has 800 teams, many of them small (5–15 people). They suspect some communities in your result are mergers of several small teams. What property of modularity-based detection explains this, and how would you address it algorithmically?

*Tests: the modularity resolution limit; when to prefer Leiden, CPM, or stochastic block models.*

**6.** You have a seed budget of $k = 5$ and want to maximize influence spread under the Independent Cascade model on a network with 1,000 users. Describe the greedy algorithm step by step — specifically, how do you select each seed, what computation is required at each step, and why you cannot select all five seeds simultaneously. Name the theorem that guarantees the quality of the result and state what it guarantees.

*Tests: greedy influence maximization mechanics; naming and applying the submodularity guarantee.*

**7.** A public health agency wants to vaccinate 500 people in a city of 200,000 to maximally reduce disease spread. They have two strategies under consideration: (a) vaccinate the 500 people with the most social contacts (highest-degree heuristic); (b) use greedy influence maximization with an IC-style transmission model calibrated to the disease's transmission probability.

Explain why strategy (a) may fail to achieve optimal coverage, with a specific structural argument. What additional information would you need to implement strategy (b)?

*Tests: centrality vs. influence distinction applied to a public health context; practical requirements of influence maximization.*

---

### Synthesis

**8.** Consider the following scenario. You are analyzing an organization's internal Slack message graph. You compute all four centrality measures and get these results for two people, X and Y:

| Measure | Person X | Person Y |
|---|---|---|
| Degree | High | Low |
| Eigenvector | High | Low |
| Betweenness | Low | High |
| Closeness | Medium | Medium |

Write a two-paragraph interpretation. What structural role does each person likely play in the organization? If you were trying to spread a new policy quickly to all employees, which person would you approach first, and for what purpose? If you were trying to identify whose departure would most disrupt information flow, which person matters more?

*Tests: integrating all four centrality measures into a coherent organizational interpretation; matching measure to question.*

**9.** The chapter states that submodularity is the structural property that makes the greedy guarantee work. Verify your understanding of submodularity by constructing a small counterexample: describe a seed-selection scenario (you can invent the network) where the marginal gain of adding a specific vertex to a seed set of size 1 is *greater* than the marginal gain of adding that same vertex to a seed set of size 3. You don't need to do formal calculations — describe the network structure that makes this happen and explain why it demonstrates the diminishing-returns property.

*Tests: intuitive verification of submodularity; understanding why diminishing returns arise from network overlap.*

---

### Challenge

**10.** Granovetter's "forbidden triad" is a related concept: if A is strongly tied to B and A is strongly tied to C, then B and C are very likely to have at least a weak tie. The triad A-B, A-C without a B-C edge is "forbidden" in most real networks.

Explain why the forbidden triad is forbidden — what network dynamic makes A-B-C without B-C unstable? Then connect this to the weak-ties result: if a B-C edge eventually forms, what happens to the information-bridging role of A? What does this imply about the long-term stability of structural brokerage positions in evolving networks?

*Tests: Granovetter's forbidden triad argument; dynamic network thinking about bridge stability.*

**11.** The chapter mentions that centrality heuristics can be "arbitrarily bad" in adversarial cases for influence maximization. Construct such a case: describe a network (in words or as an edge list) with $n$ vertices and a seed budget $k = 2$, where selecting the two highest-degree vertices produces influence spread that is a factor of roughly $n/4$ worse than the optimal two-seed selection. Explain why the greedy algorithm with submodularity would not make the same mistake.

*Tests: adversarial construction against degree heuristics; understanding why submodularity-based greedy has no such adversarial case.*

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

1. What's the network? Vertices, edges, directed or undirected,
   weighted or binary. If I'm describing a network without being
   able to name the edges, I'm not yet in network territory.

2. What's the actual question?
   - "Who's most central?" (centrality — but which kind?)
   - "Who clusters together?" (community detection)
   - "If I activate a small set, how far does influence spread?"
     (influence maximization)
   - Something else?

3. Pick the right centrality.
   - Degree: most connections.
   - Betweenness: lies on most shortest paths between others
     (broker, bottleneck).
   - Closeness: short average distance to all others.
   - Eigenvector / PageRank: connected to important others.
   Each answers a different question. Which question am I asking?

4. If it's influence maximization: the chapter notes that greedy
   with submodularity gives a (1 − 1/e) guarantee. What's the
   diffusion model — linear-threshold, independent-cascade?
   What's the seed-set budget?

5. What are the limits of network-based prediction here? The
   chapter is explicit that not everything network-shaped is
   network-structured — sometimes the relationships I'm treating
   as edges are noise.

PART TWO — Synthesis across the diary.

Now look across all eight entries (you have them in your project
context). Surface:

1. Recurring failure modes in my decision-making. Where do I
   consistently underweight priors? Where do I over-explore or
   under-explore? Where do I model opponents as more rational
   than they are? Where do I treat non-stationary situations as
   if they were stationary?

2. The methods I reach for naturally vs. the ones I avoid.
   Patterns. Some readers are Bayesian by instinct and
   under-use game-theoretic framings; some are the reverse.

3. The outcomes I should chase down. Each entry had a "What
   would change my mind" commitment. Which of those outcomes
   can be observed in the next 1, 3, 6 months? Make me a list
   with check-in dates.

4. One sentence that captures what the diary has taught me
   about how I decide. Not flattering. Honest.

Output: two markdown sections. The first is the standard diary
entry (same heading template as previous chapters). The second
is a "Diary synthesis — [date]" section with the four numbered
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

## AI Wayback Machine

The ideas in this chapter didn't appear from nowhere. **Mark Granovetter** published "The Strength of Weak Ties" in 1973 — arguing that the loose acquaintances you barely know matter more for job-finding and information flow than your closest friends. It became one of the most-cited papers in the history of sociology.

**Run this:**

```
Who is Mark Granovetter, and how does his 1973 paper on the strength
of weak ties connect to the social network analysis we covered in this
chapter? Keep it to three paragraphs. End with the single most
surprising thing about his career or ideas.
```

→ Search **"Mark Granovetter"** on Wikipedia. See what the model got right, got wrong, or left out.

**Now make the prompt better.** Try one of these:

- Ask it to explain Granovetter's "forbidden triad" in plain language and connect it to the clustering coefficient measurements you ran.
- Add a constraint: "Answer as the abstract of a follow-up paper to 'The Strength of Weak Ties,' written fifty years later."

What changes? What gets better? What gets wrong?
